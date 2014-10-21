on getTitle()
		tell application id "com.google.chrome"
			using terms from application "Google Chrome"
				return title of active tab of first window
			end using terms from
		end tell
end
on getBody()
		tell application id "com.google.chrome"
			using terms from application "Google Chrome"
				return get URL of active tab of first window
			end using terms from
		end tell
end