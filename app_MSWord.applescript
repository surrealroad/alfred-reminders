on getTitle()
	tell application id "com.microsoft.Word"
		using terms from application "Microsoft Word"
			tell active window
				tell its document
					return name
				end tell
			end tell
		end using terms from
	end tell
end getTitle
on getBody()
	tell application "System Events"
		tell process "Microsoft Word"
			return value of attribute "AXDocument" of window 1
		end tell
	end tell
end getBody