tell application "BBEdit"
	set tw to the tab width of the first text window
	if tw = 2 then
		set tw to 4
	else if tw = 4 then
		set tw to 8
	else
		set tw to 2
	end if
	set the tab width of the first text window to tw
end tell
