on getTitle()
	tell application id "com.adobe.Acrobat.PRO"
		using terms from application "Adobe Acrobat"
			tell front document
				return name
			end tell
		end using terms from
	end tell
	return "Adobe PDF"
end getTitle
on getBody()
	tell application "System Events"
		tell process "AdobeAcrobat"
			return value of attribute "AXDocument" of window 1
		end tell
	end tell
end getBody