tell application "BBEdit"
    if the first text document exists then
        first text document's file as alias
        tell application "Finder" to folder of result as alias
        POSIX path of result
    else
        beep
    end if
end tell
