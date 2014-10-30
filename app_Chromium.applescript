on getTitle()
tell application id "org.chromium.Chromium"
			using terms from application "Chromium"
				return title of active tab of first window
			end using terms from
		end tell
end getTitle
on getBody()
tell application id "org.chromium.Chromium"
			using terms from application "Chromium"
				return get URL of active tab of first window
			end using terms from
		end tell
end getBody