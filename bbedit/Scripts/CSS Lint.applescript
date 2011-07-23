(*
CSS Syntax Checker for BBEdit
John Gruber
http://daringfireball.net/projects/csschecker/

Version: 1.0.0
Date: 5 Sept 2005

This AppleScript is released under a Creative Commons Attribution-ShareAlike License:
<http://creativecommons.org/licenses/by-sa/2.0/>

*)

-- This global is used to track the line number offset of CSS
-- in inline <style>...</style> tags in an HTML document:
global g_line_offset

on run
	-- The run handler is called when the script is invoked normally,
	-- such as from BBEdit's Scripts menu.
	my check_CSS_syntax()
end run


on menuselect()
	-- The menuselect() handler gets called when the script is invoked
	-- by BBEdit as a menu script. Save this script, or an alias to it,
	-- as "Check¥Document Syntax" in the "Menu Scripts" folder in your
	-- "BBEdit Support" folder.
	tell application "BBEdit"
		try
			if (source language of window 1 is "CSS") then
				-- It's a CSS file, so tell BBEdit *not* to
				-- continue with its HTML syntax check:
				my check_CSS_syntax()
				return true
			else
				return false
			end if
		end try
	end tell
end menuselect


on check_CSS_syntax()
	
	set g_line_offset to 0
	set css_path to my get_CSS_path()
	if css_path is "" then return -- Don't proceed if we don't have a path to the css file
	
	try
		set check_result to my screenscrape_W3C_CSS_validator(css_path)
	on error err_text number err_num
		display dialog err_text
	end try
	
	set css_error_list to {}
	
	tell application "BBEdit"
		set current_file to file of text window 1
		set document_name to name of document of text window 1
		
		if check_result starts with "No syntax errors detected" then
			display alert "CSS Syntax OK" message Â
				"No CSS errors or warnings were found in Ò" & document_name & "Ó."
			return
		end if
		
		-- Put together the results for the browser:
		repeat with err in (every paragraph of check_result)
			if (err as text) is not equal to "" then
				try
					if (word 1 of err) is "Error" then
						set my_kind to error_kind
					else if (word 1 of err) is "Warning" then
						set my_kind to warning_kind
					else
						set my_kind to "Unknown"
					end if
				on error
					set my_kind to "Unknown"
				end try
				
				if my_kind is not "Unknown" then
					set old_delims to AppleScript's text item delimiters
					set AppleScript's text item delimiters to {tab}
					set err_description to text item 2 of err
					set AppleScript's text item delimiters to old_delims
					
					try
						set line_num to word 2 of err as integer
					on error
						set line_num to 1
					end try
					
					-- Account for line offset if we're checking CSS in a <style> tag:
					set line_num to line_num + g_line_offset
					
					set s_offset to characterOffset of first character of line line_num of window 1
					set e_offset to characterOffset of last character of line line_num of window 1
					set err_list_item to {result_kind:Â
						my_kind, result_file:Â
						current_file, result_line:Â
						line_num, start_offset:(s_offset - 1), end_offset:e_offset, message:Â
						err_description as text}
					copy err_list_item to end of css_error_list
				end if
			end if
		end repeat
		
		make new results browser with data css_error_list with properties {name:"CSS Syntax Errors"}
		
	end tell
end check_CSS_syntax


on get_CSS_path()
	-- Input: None
	-- Returns:
	--	Path to the CSS file to be passed to the validator. Returns an empty
	--	string if an error occurs or if the frontmost window is an untitled
	--	document. If a temp file needs to be written, this is where it happens.
	tell application "BBEdit"
		try
			-- Make sure the frontmost window is a text window, and
			-- that it is not an untitled (never saved) document.
			set w to window 1
			if (class of w is not text window) then error
			if not (on disk of w) then error number 10000
		on error number n
			-- As of BBEdit 8.2.3, result browser entries must be associated
			-- with a file on disk.
			if (n = 10000) then
				display alert Â
					"CSS Syntax Check: untitled document error" message Â
					"CSS Syntax Check does not work with untitled documents. Save your document, then try again." as warning
			else
				beep
			end if
			return "" -- Don't proceed with the rest of the script.
		end try
		
		set is_dirty to modified of w
		set linebreaks to (line breaks of document of w)
		
		-- Search for a <style>...</style> tag pair
		set s_opts to {search mode:grep, starting at top:true, returning results:true}
		set style_tag_match to find Â
			"(?s)<style[^>]*>(.+?)</style>" searching in text 1 Â
			of text document 1 options s_opts without selecting match
		
		if ((source language of w is not "CSS") and (found of style_tag_match)) then
			-- If it's not a CSS document and there is a <style> tag, just check the
			-- contents of the <style> tag
			set style_contents to grep substitution of "\\1"
			
			-- We need to know which line the "<style>" opening tag ends on (which is not necessarily
			-- the line it starts on:
			set style_match to find "<style[^>]*>" searching in text 1 of text document 1 options s_opts without selecting match
			set tag_props to properties of found object of style_match
			set g_line_offset to (endLine of tag_props) - 1
			
			-- Write just the CSS contents of the <style>...</style> tag to a temp file
			set tmp to (path to temporary items folder)
			set tmp_file to (tmp as string) & name of window 1
			my write_file_as_UTF8(tmp_file, style_contents)
			set css_path to quoted form of POSIX path of (tmp_file as alias)
			
		else if (is_dirty) or (linebreaks is not equal to Unix) then
			set tmp to (path to temporary items folder)
			set tmp_file to (tmp as string) & name of window 1
			my write_file_as_UTF8(tmp_file, text of w)
			set css_path to quoted form of POSIX path of (tmp_file as alias)
		else
			set css_path to quoted form of POSIX path of (file of w as alias)
		end if
	end tell
	return css_path
end get_CSS_path



on screenscrape_W3C_CSS_validator(css_path)
	-- Input: Quoted form of posix path of css file
	-- Returns: Screenscraped results from validator in the following format:
	
	-- Find the "CSS Check Syntax.pl" Perl script; assume it is
	-- in the same folder as this AppleScript file.
	local applescript_path, parent_folder, perl_script_path
	set applescript_path to path to me
	
	-- If the script is run from Script Editor, "path to me" returns
	-- the path to Script Editor.app
	if ((applescript_path as text) ends with "Script Editor.app:") then
		tell application "AppleScript Editor" to set applescript_path to path of document 1
		-- The following POSIX path to POSIX file coercion doesn't work within
		-- a tell block (and I don't know why):
		set applescript_path to POSIX file applescript_path as alias
	end if
	
	tell application "System Events"
		set parent_folder to container of applescript_path
		set parent_folder to POSIX path of parent_folder
	end tell
	set perl_script_path to quoted form of (parent_folder & "/CSS Syntax Check.pl")
	
	-- Note: do shell script must run outside tell BBEdit block
	set my_shell_cmd to "perl" & space & perl_script_path & space & css_path as string
	return do shell script my_shell_cmd -- without altering line endings
	
end screenscrape_W3C_CSS_validator



on write_file_as_UTF8(the_file, the_content)
	--	the_file: HFS-style path to file to write
	--	the_content: string to write to file; can be Unicode text, will be converted to UTF-8
	local file_ref
	set file_ref to open for access the_file with write permission
	try
		set eof file_ref to 0
		write the_content to file_ref as Çclass utf8È
		close access file_ref
	on error err_msg number err_num
		close access file_ref
		error err_msg number err_num
	end try
end write_file_as_UTF8
