tell application "BBEdit"
	set dfs to display font size of text window 1
	if dfs > 4 then
		set dfs to dfs - 1
		set display font size of text window 1 to dfs
	else
		beep
	end if
end tell
