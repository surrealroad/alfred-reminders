on getTitle()
	tell application id "com.microsoft.PowerPoint"
		using terms from application "Microsoft PowerPoint"
			tell active window
				tell its presentation
					return name
				end tell
			end tell
		end using terms from
	end tell	
end getTitle
on getBody()
	tell application "System Events"
		tell process "Microsoft PowerPoint"
			return value of attribute "AXDocument" of window 1
		end tell
	end tell
end getBody