tell application "BBEdit"
	tell the text of the first text document
		detab 2
		replace "[ \\t]+$" using "" options {search mode:grep, wrap around:true}
	end tell
end tell
