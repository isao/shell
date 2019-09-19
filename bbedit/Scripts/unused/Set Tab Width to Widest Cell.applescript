--  Get the input.
tell application "BBEdit"
	set input to the selection of text window 1 as text
	if input is "" then
		set input to the text of window 1
	end if
end tell

--  Break the input into rows.
set inputRows to paragraphs of input
if (count of inputRows) is 0 then error "no rows found"

--  Find the longest cell.
set maximumInputCellLength to 0
set oldTextItemDelimiters to AppleScript's text item delimiters
set AppleScript's text item delimiters to {tab}
--  Iterate over the rows.
repeat with inputRow in inputRows
	set inputCells to text items of inputRow
	--  Iterate over the cells in each row.
	repeat with inputCell in inputCells
		set inputCellLength to the length of inputCell
		if inputCellLength > maximumInputCellLength then Â
			set maximumInputCellLength to inputCellLength
	end repeat
end repeat
set AppleScript's text item delimiters to oldTextItemDelimiters

tell application "BBEdit"
	set the tab width of text window 1 to maximumInputCellLength + 1
end tell