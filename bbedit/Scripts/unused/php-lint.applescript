property phpref : "/usr/bin/env php -l "

(* on my PHP 4.3.2, php_msg is something like (leading carraige return):
  Parse error: parse error, expecting `')'' in /Volumes/iyagi/htdocs/buildrelations/class/request.class.php on line 81
  Errors parsing /Volumes/iyagi/htdocs/buildrelations/class/request.class.php
*)

on phpErrLine(php_msg, bbfref)
	set errIndicator to " in " & (POSIX path of bbfref) & " on line "
	set off to (offset of errIndicator in php_msg) + (length of errIndicator)
	get text off thru -1 of php_msg
	return first paragraph of result as integer
end phpErrLine

on phpErrMsg for bbfref out of php_msg
	set errIndicator to " in " & (POSIX path of bbfref) & " on line "
	return text 2 thru (offset of errIndicator in php_msg) of php_msg
end phpErrMsg

tell application "BBEdit"
	tell first text document
		if modified then save
	end tell
	get file of first text document
	set bbfref to result
end tell

try
	do shell script phpref & POSIX path of bbfref
	display dialog "Ok: " & result buttons {"finished checking"} default button 1
on error php_msg
	set err_line to phpErrLine(php_msg, bbfref)
	set show_err to phpErrMsg out of php_msg for bbfref
	tell application "BBEdit"
		tell text window 1
			set off to (characterOffset of line err_line)
			set len to (length of line err_line)
		end tell
		
		make new results browser with data {{result_kind:error_kind, result_file:bbfref, start_offset:off, end_offset:(off + len), result_line:err_line, message:show_err}} with properties {name:"bb php lint"}
		
	end tell
end try
