property stuff_found_in_a_phpunit_test : "extends PHPUnit"

tell application "BBEdit"
	if exists (first text document whose contents contains stuff_found_in_a_phpunit_test) then
		get the file of the first text document whose contents contains stuff_found_in_a_phpunit_test
		tell application "Finder" to set the unitest to the POSIX path of result
		tell application "Terminal"
			if exists (first window whose busy is false) then
				do script "phpunit " & the unitest in the first window whose busy is false
			else
				do script "phpunit " & the unitest
			end if
		end tell
		beep 11
	else
		display alert "hm, doesn't look like there are any PHPUnit tests. I'm gonna chill, dude" buttons "sweet, dude"
	end if
end tell

