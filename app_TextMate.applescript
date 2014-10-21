on getTitle()
		tell application "TextMate" -- v1 & v2
			using terms from application "TextMate"
				tell front document
					return name
				end tell
			end using terms from
		end tell
end getTitle
on getBody()
		tell application "TextMate" -- v1 & v2
			using terms from application "TextMate"
				tell front document
					return "file://localhost" & my path2url(path)
				end tell
			end using terms from
		end tell
end getBody

on path2url(thePath)
	return do shell script "python -c \"import urllib, sys; print (urllib.quote(sys.argv[1]))\" " & quoted form of thePath
end path2url