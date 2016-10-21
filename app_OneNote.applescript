on getTitle()
	tell application "System Events"
		tell process "Microsoft OneNote"
			click menu item "Rename Page" of menu 1 of menu item "Pages" of menu 1 of menu bar item "Notebooks" of menu bar 1
			delay 0.5
			tell application "System Events"
				keystroke "c" using command down
				delay 0.1
				key code 123
				set myTitle to the clipboard
				return myTitle
			end tell
		end tell
	end tell
end getTitle
on getBody()
	tell application "System Events"
		tell process "Microsoft OneNote"
			click menu item "Copy Link to Page" of menu 1 of menu item "Pages" of menu 1 of menu bar item "Notebooks" of menu bar 1
			delay 0.5
			set myBody to the clipboard
			set lineStart to offset of ".aspx/" in myBody
			if lineStart is not equal to 0 then
				set lineContent to text (lineStart + 6) Â
					thru ((offset of "?" in myBody) - 1) Â
					of myBody
				set myBody to lineContent
			end if
			return myBody
		end tell
	end tell
end getBody