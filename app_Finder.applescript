on getTitle()
		tell application id "com.apple.Finder"
			using terms from application "Finder"
				set theFiles to selection
				return name of (first item of theFiles)
			end using terms from
		end tell
end getTitle
on getBody()
set osver to system version of (system info)
		tell application id "com.apple.Finder"
			using terms from application "Finder"
				set theFiles to selection
				if osver contains "10.9" or osver contains "10.10" then 
				set theBody to "file://"
				else
				set theBody to "file://localhost"
				end
				return theBody & my path2url(POSIX path of ((first item of theFiles) as string))
			end using terms from
		end tell
end getBody