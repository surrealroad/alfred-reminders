on getTitle()
		tell application id "com.apple.AddressBook"
			set theContacts to selection
			return name of first item of theContacts
		end tell
end getTitle
on getBody()
		tell application id "com.apple.AddressBook"
			set theContacts to selection
			return "addressbook://" & id of first item of theContacts
		end tell
end getBody