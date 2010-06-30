tell application "Finder"
	if (count of Finder windows) > 0 then
		set cwd to the POSIX path of (target of the front Finder window as alias)
	else 
		set cwd to "~"
	end if
	return cwd
end tell