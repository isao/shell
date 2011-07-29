tell application "BBEdit"
	set tw to the tab width of the first text window
	if tw = 2 then
		4
	else if tw = 4 then
		8
	else
		2
	end if
	set the tab width of the first text window to result
end tell
