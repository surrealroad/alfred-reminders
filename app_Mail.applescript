on getTitle()
		tell application id "com.apple.mail"
			set selectedMails to selection
			set theMessage to first item of selectedMails
			return the subject of theMessage & " (From " & the sender of theMessage & ")"
		end tell
end getTitle
on getBody()
		tell application id "com.apple.mail"
			set selectedMails to selection
			set theMessage to first item of selectedMails
			return "message:%3C" & message id of theMessage & "%3E"
		end tell
end getBody