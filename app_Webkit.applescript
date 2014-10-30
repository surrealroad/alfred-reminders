on getTitle()
		tell application id "org.webkit.nightly.WebKit"
			using terms from application "Safari"
				set theTab to front document
				return name of theTab
			end using terms from
		end tell
end getTitle
on getBody()
		tell application id "org.webkit.nightly.WebKit"
			using terms from application "Safari"
				set theTab to front document
				return URL of theTab
			end using terms from
		end tell
end getBody