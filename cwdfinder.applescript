tell application "Finder"
    if first window exists then
        first window's target as alias
    else
        get desktop as alias
    end if
    result's POSIX path
end tell
