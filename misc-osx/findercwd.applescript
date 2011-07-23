tell app "Finder"
  if front Finder window exists then
    (front Finder window's target as alias)'s POSIX path
  else
    "~/Desktop"
  end if
end tell
