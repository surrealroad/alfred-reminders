on getTitle()
		tell application "FoldingText" -- v1 & v2
			using terms from application "FoldingText"
				return name of front document
			end using terms from
		end tell
end getTitle
on getBody()
		tell application "FoldingText"
			using terms from application "FoldingText"
				set theFile to file of front document
				return "file://localhost" & my path2url(POSIX path of theFile)
			end using terms from
		end tell
end getBody

on path2url(thePath)
	return do shell script "python -c \"import urllib, sys; print (urllib.quote(sys.argv[1]))\" " & quoted form of thePath
end path2url