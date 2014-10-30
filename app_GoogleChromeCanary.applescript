on getTitle()
		tell application id "com.google.chrome.canary"
			using terms from application "Google Chrome Canary"
				return title of active tab of first window
			end using terms from
		end tell
end getTitle
on getBody()
		tell application id "com.google.chrome.canary"
			using terms from application "Google Chrome Canary"
				return get URL of active tab of first window
			end using terms from
		end tell
end getBody