reminderFromApplication("Finder.app")

on reminderFromApplication(theApplication)
	set theText to ""
	set theBody to ""
	if theApplication is "Google Chrome.app" then
		tell application id "com.google.chrome"
			using terms from application "Google Chrome"
				set theText to title of active tab of first window
				set theBody to get URL of active tab of first window
			end using terms from
		end tell
	else if theApplication is "Chromium.app" then
		tell application id "org.chromium.Chromium"
			using terms from application "Chromium"
				set theText to title of active tab of first window
				set theBody to get URL of active tab of first window
			end using terms from
		end tell
	else if theApplication is "Google Chrome Canary.app" then
		tell application id "com.google.chrome.canary"
			using terms from application "Google Chrome Canary"
				set theText to title of active tab of first window
				set theBody to get URL of active tab of first window
			end using terms from
		end tell
	else if theApplication is "Safari.app" then
		tell application id "com.apple.safari"
			using terms from application "Safari"
				set theTab to front document
				set theText to name of theTab
				set theBody to URL of theTab
			end using terms from
		end tell
	else if theApplication is "Webkit.app" then
		tell application id "org.webkit.nightly.WebKit"
			using terms from application "Safari"
				set theTab to front document
				set theText to name of theTab
				set theBody to URL of theTab
			end using terms from
		end tell
	else if theApplication is "Mail.app" then
		tell application id "com.apple.mail"
			set selectedMails to selection
			set theMessage to first item of selectedMails
			set theBody to "message:%3C" & message id of theMessage & "%3E"
			set theText to the subject of theMessage & " (From " & the sender of theMessage & ")"
		end tell
	else if theApplication is "Address Book.app" or theApplication is "Contacts.app" then
		tell application id "com.apple.AddressBook"
			set theContacts to selection
			set theText to name of first item of theContacts
			set theBody to "addressbook://" & id of first item of theContacts
		end tell
	else if theApplication is "Finder.app" then
		set osver to system version of (system info)
		tell application id "com.apple.Finder"
			using terms from application "Finder"
				set theFiles to selection
				set theText to name of (first item of theFiles)
				if osver contains "10.9" then 
				set theBody to "file://"
				else
				set theBody to "file://localhost"
				end
				set theBody to theBody & my path2url(POSIX path of ((first item of theFiles) as string))
			end using terms from
		end tell
	else if theApplication is "TextEdit.app" then
		tell application id "com.apple.TextEdit"
			using terms from application "TextEdit"
				tell front document
					set theText to name
				end tell
				set thePath to path of front document
				if thePath is "" then
					set theBody to text of front document
				else
					set theBody to "file://localhost" & my path2url(thePath)
				end if
			end using terms from
		end tell
	else if theApplication is "TextMate.app" then
		tell application "TextMate" -- v1 & v2
			using terms from application "TextMate"
				tell front document
					set theText to name
					set theBody to "file://localhost" & my path2url(path)
				end tell
			end using terms from
		end tell
	else if theApplication is "Vienna.app" then
		tell application id "uk.co.opencommunity.vienna2"
			using terms from application "Vienna"
				set theText to title of current article
				set theBody to link of current article
			end using terms from
		end tell
	else if theApplication is "Omnifocus.app" then
		tell application "OmniFocus" -- v1 & v2
			using terms from application "OmniFocus"
				tell content of first document window of front document
					--Get selection
					set validSelectedItemsList to value of (selected trees where class of its value is not item and class of its value is not folder)
					set theText to name of first item of validSelectedItemsList
					--set theBody to note of first item of validSelectedItemsList
					set theBody to "omnifocus:///task/" & id of first item of validSelectedItemsList
					--return selection
				end tell
			end using terms from
		end tell
	else if theApplication is "FoldingText.app" then
		tell application id "com.foldingtext.FoldingText"
			using terms from application "FoldingText"
				set theText to name of front document
				set theFile to file of front document
				set theBody to "file://localhost" & my path2url(POSIX path of theFile)
			end using terms from
		end tell
	end if
	return {theText:theText, theBody:theBody}
end reminderFromApplication

on path2url(thePath)
	return do shell script "python -c \"import urllib, sys; print (urllib.quote(sys.argv[1]))\" " & quoted form of thePath
end path2url

