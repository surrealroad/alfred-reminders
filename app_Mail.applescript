on getTitle()
	tell application id "com.apple.mail"
		using terms from application "Mail"
			set selectedMails to selection
			--sort newest messages to the top
			repeat with i from 1 to (count of selectedMails) - 1
				repeat with j from i + 1 to count of selectedMails
					set iMessage to item i of selectedMails
					set jMessage to item j of selectedMails
					if date received of jMessage is greater than date received of iMessage then
						set temp to item i of selectedMails
						set item i of selectedMails to item j of selectedMails
						set item j of selectedMails to temp
					end if
				end repeat
			end repeat
			set theMessage to first item of selectedMails
			return the subject of theMessage & " (From " & the sender of theMessage & ")"
		end using terms from
	end tell
end getTitle
on getBody()
	tell application id "com.apple.mail"
		using terms from application "Mail"
			set selectedMails to selection
			--sort newest messages to the top
			repeat with i from 1 to (count of selectedMails) - 1
				repeat with j from i + 1 to count of selectedMails
					set iMessage to item i of selectedMails
					set jMessage to item j of selectedMails
					if date received of jMessage is greater than date received of iMessage then
						set temp to item i of selectedMails
						set item i of selectedMails to item j of selectedMails
						set item j of selectedMails to temp
					end if
				end repeat
			end repeat
			set theMessage to first item of selectedMails
			return "message://<" & message id of theMessage & ">"
		end using terms from
	end tell
end getBody