on getTitle()
		tell application id "com.apple.TextEdit"
			using terms from application "TextEdit"
				tell front document
					return name
				end tell
			end using terms from
		end tell
end getTitle
on getBody()
		tell application id "com.apple.TextEdit"
			using terms from application "TextEdit"
				set thePath to path of front document
				if thePath is "" then
					return text of front document
				else
					return "file://localhost" & my path2url(thePath)
				end if
			end using terms from
		end tell
end getBody

on path2url(thePath)
	return do shell script "python -c \"import urllib, sys; print (urllib.quote(sys.argv[1]))\" " & quoted form of thePath
end path2url