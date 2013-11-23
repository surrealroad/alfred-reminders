property pocketconsumerkey : "12650-d359d8ed994f63dbef6b012b"
property closeReminders : false
property closeNotes : false
property updateURL : "http://www.surrealroad.com/alfred/version-check.php"
property downloadURL : "http://www.surrealroad.com/alfred/download.php"
property workflowFolder : do shell script "pwd"

-- localisation

property overdueString : "overdue"
property allString : "all"
property refreshString : "refresh"

property reminderHelpItems : {"do something crazy", Â
	"today release the hamsters into the wild", Â
	"tomorrow bring about financial ruin upon my enemies", Â
	"in 5 minutes drop everything", Â
	"in 2 hours laugh out loud in random thoughts list", Â
	"in 3 days 1 hour pick stuff up off the floor", Â
	"on 24/12/13 to forget everything I know about things in movies", Â
	"on 12 June 15 to come up with some interesting ideas", Â
	"on 11 12 13 to check what the weather's like", Â
	"on 31-12-99 23:22 to panic about the millennium bug", Â
	"at 2pm to wait for nothing in particular", Â
	"thursday at 15.30 to ask some difficult questions"}

property supportedReminderApplications : {Â
	{appname:"Safari.app", icon:"Safari.png"}, Â
	{appname:"WebKit.app", icon:"Safari.png"}, Â
	{appname:"Google Chrome.app", icon:"Chrome.png"}, Â
	{appname:"Mail.app", icon:"Mail.png"}, Â
	{appname:"Contacts.app", icon:"Address Book.png"}, Â
	{appname:"Address Book.app", icon:"Address Book.png"}, Â
	{appname:"Finder.app", icon:"Finder.png"}, Â
	{appname:"Chromium.app", icon:"Chromium.png"}, Â
	{appname:"TextEdit.app", icon:"TextEdit.png"}, Â
	{appname:"Textmate.app", icon:"TextMate.png"}, Â
	{appname:"Vienna.app", icon:"RSS.png"}, Â
	{appname:"OmniFocus.app", icon:"OmniFocus.png"}, Â
	{appname:"FoldingText.app", icon:"App.png"}, Â
	{appname:"Google Chrome Canary.app", icon:"Chrome Canary.png"} Â
		}


-- pocket specific

on pocketRequestToken()
	set cmd to "curl -X POST --connect-timeout 5"
	set cmd to cmd & curlAddHeader("Content-Type: application/json; charset=UTF-8")
	set cmd to cmd & curlAddHeader("X-Accept: application/json")
	set cmd to cmd & curlAddHeader("Host: getpocket.com")
	set cmd to cmd & curlAddData("{\"consumer_key\":\"" & pocketconsumerkey & "\", \"redirect_uri\":\"pocketapp1234:authorizationFinished\"}")
	set cmd to cmd & " https://getpocket.com/v3/oauth/request"
	--return cmd
	return do shell script cmd
end pocketRequestToken


-- reminders specific

on setRemindersActive()
	tell application "System Events"
		set remindersIsRunning to (bundle identifier of processes) contains "com.apple.reminders"
	end tell
	if remindersIsRunning then
		set closeReminders to false
	else
		set closeReminders to true
	end if
end setRemindersActive

on getCachedReminderList(wf, cacheFile)
	set existingReminders to {}
	try
		set reminderCount to wf's get_value("reminderCount", cacheFile)
		repeat with i from 1 to reminderCount
			set end of existingReminders to wf's get_value("reminder" & i, cacheFile)
		end repeat
	end try
	return existingReminders
end getCachedReminderList

on fetchReminderList(wf, cacheFile, cacheExpires)
	try
		set timestamp to wf's get_value("timestamp", cacheFile)
		if (current date) - timestamp is less than cacheExpires then
			return getCachedReminderList(wf, cacheFile)
		end if
	end try
	return cacheReminders(wf, cacheFile)
end fetchReminderList

on cacheReminders(wf, cacheFile)
	set cacheTimeout to 30
	set cacheInProgress to wf's get_value("cacheInProgress", cacheFile)
	set existingReminders to getCachedReminderList(wf, cacheFile)
	
	if cacheInProgress is not missing value then
		-- return previous cache results, even if they are out of date
		if (my unixtime(current date)) - cacheInProgress is less than cacheTimeout then return existingReminders
	end if
	
	wf's set_value("closeReminders", closeReminders, cacheFile)
	
	-- spawn cache process
	spawnReminderCache(workflowFolder & "/cache-reminders.scpt", true, "")
	return existingReminders
end cacheReminders

on spawnReminderCache(cacheScript, runInBackground, parameters)
	-- spawn cache process
	if runInBackground then
		do shell script "osascript " & quoted form of cacheScript & space & parameters & " > /dev/null 2>&1 & "
	else
		do shell script "osascript " & quoted form of cacheScript & space & parameters
	end if
end spawnReminderCache

on filterReminders(reminderList, theText, theDate, theList)
	set theResult to {}
	if reminderList is not missing value then
		repeat with reminder_item in reminderList
			set matchedText to false
			set matchedDate to false
			set matchedList to false
			
			if theText is missing value or theText is "" or theText is Â
				allString or theText is overdueString Â
				or theText is refreshString Â
				or reminder_item's title contains theText then
				set matchedText to true
			end if
			
			try
				set reminddate to (reminder_item's reminddate)
			on error
				set reminddate to missing value
			end try
			try
				set duedate to (reminder_item's duedate)
			on error
				set duedate to missing value
			end try
			if (theText is overdueString) and (duedate is not missing value) and (duedate is less than (current date)) then
				set matchedDate to true
			else if theText is overdueString then
				set matchedDate to false
			else if theDate is missing value or theDate is "" then
				set matchedDate to true
			else if (reminddate is not missing value) and ((date string of theDate) is equal to (date string of reminddate)) then
				set matchedDate to true
			else if (duedate is not missing value) and ((date string of theDate) is equal to (date string of duedate)) then
				set matchedDate to true
			end if
			
			if theList is missing value or theList is "" or reminder_item's parentlist contains theList then
				set matchedList to true
			end if
			
			if matchedText and matchedDate and matchedList then
				try
					set body to (reminder_item's body)
				on error
					set body to missing value
				end try
				if body is not missing value then
					set infoText to " (" & reminder_item's body & ")"
				else if duedate is not missing value then
					set infoText to ((" (due on " & (reminder_item's duedate) as string) & ", started on " & (reminder_item's creationdate) as string) & ")"
				else
					set infoText to (" (started on " & (reminder_item's creationdate) as string) & ")"
				end if
				set end of theResult to my alfred_result_item_with_icon(reminder_item's uid, reminder_item's title, Â
					"Set as complete" & infoText, "uid:" & reminder_item's uid, "yes", "checked.png")
			end if
		end repeat
	end if
	return theResult
end filterReminders

on parseReminder(q)
	set theText to ""
	set theDate to ""
	set theList to ""
	set theApplication to ""
	set theIcon to ""
	set valid to ""
	
	if first word of q is "this" then
		set theApplication to my frontmostapp()
		try
			set q to (characters 6 thru -1 of q) as string
		on error
			set q to ""
		end try
	end if
	
	if q is not allString and q is not overdueString and q is not refreshString then
		
		try
			if last word of q is "list" then
				set old_delims to AppleScript's text item delimiters
				set AppleScript's text item delimiters to space
				set theIndex to 0
				set itemList to text items of q
				repeat with i from (count of itemList) to 1 by -1
					if item i of itemList is equal to "in" then
						set theIndex to i
						exit repeat
					end if
				end repeat
				if theIndex is greater than or equal to 1 then
					try
						set theList to (items (theIndex + 1) thru -2 of itemList) as string
						if theIndex is greater than 1 then
							set q to (items 1 thru (theIndex - 1) of itemList) as string
						else
							set q to ""
						end if
					end try
				end if
				set AppleScript's text item delimiters to old_delims
			end if
		end try
		
		try
			if first word of q is "tomorrow" then
				set q to my middleText(q, 2, -1)
				set theDate to ((current date) + days)
				set valid to "yes"
			else if first word of q is "today" then
				set q to my middleText(q, 2, -1)
				set theDate to (current date)
				set valid to "yes"
			else if my datefromweekday(first word of q) is not false then
				set theDate to my datefromweekday(first word of q)
				set q to my middleText(q, 2, -1)
				set valid to "yes"
			end if
		end try
		
		try
			if theDate is "" and first word of q is "in" and Â
				(third word of q is "minutes" or third word of q is "minute") then
				set theText to my middleText(q, 4, -1)
				set theDate to ((current date) + minutes * (my middleText(q, 2, 2)))
				set valid to "yes"
			else if theDate is "" and first word of q is "in" and Â
				(third word of q is "days" or third word of q is "day") then
				set theText to my middleText(q, 4, -1)
				set theDate to ((current date) + days * (my middleText(q, 2, 2)))
				-- check for x days y hours
				try
					if (fifth word of q is "hours" or fifth word of q is "hour") then
						set theText to my middleText(q, 6, -1)
						set theDate to (theDate + hours * (my middleText(q, 4, 4)))
					end if
				end try
				set valid to "yes"
			else if theDate is "" and first word of q is "in" and Â
				(third word of q is "hours" or third word of q is "hour") then
				set theText to my middleText(q, 4, -1)
				set theDate to ((current date) + hours * (my middleText(q, 2, 2)))
				try
					if (fifth word of q is "minutes" or fifth word of q is "minute") then
						set theText to my middleText(q, 6, -1)
						set theDate to (theDate + minutes * (my middleText(q, 4, 4)))
					end if
				end try
				set valid to "yes"
			else if theDate is "" and first word of q is "on" then
				set old_delims to AppleScript's text item delimiters
				set AppleScript's text item delimiters to space
				set theIndex to 0
				set itemList to text items of q
				repeat with i from 2 to the count of itemList
					if item i of itemList is equal to "to" then
						set theIndex to i
						exit repeat
					end if
				end repeat
				if theIndex is greater than 0 then
					try
						set theText to (items (theIndex + 1) thru -1 of itemList) as string
						set theDate to date ((items 2 thru (theIndex - 1) of itemList) as string)
						set valid to "yes"
					on error
						set valid to "no"
					end try
				end if
				set AppleScript's text item delimiters to old_delims
			else if first word of q is "at" then
				set old_delims to AppleScript's text item delimiters
				set AppleScript's text item delimiters to space
				set theIndex to 0
				set itemList to text items of q
				repeat with i from 2 to the count of itemList
					if item i of itemList is equal to "to" then set theIndex to i
				end repeat
				if theIndex is greater than 0 then
					try
						set theText to (items (theIndex + 1) thru -1 of itemList) as string
						set theTimeStr to (items 2 thru (theIndex - 1) of itemList) as string
						if theDate is "" then
							set theDate to my convertTime(theTimeStr)
						else
							set (time of theDate) to time of (my convertTime(theTimeStr))
						end if
						
						if theDate is not "" then
							set valid to "yes"
						else
							set valid to "no"
						end if
					on error
						set valid to "no"
					end try
				end if
				set AppleScript's text item delimiters to old_delims
			else
				set theText to q
				if theText is not "" then set valid to "yes"
			end if
		end try
	else
		-- "r all", "r refresh"
		set theText to q
	end if
	
	if theApplication is "" and (theText is "" or valid is "no") then
		set valid to "no"
	else if theApplication is not "" and isAppSupported(theApplication, "Reminders") then
		set valid to "yes"
	end if
	set theText to (theText as string)
	if theIcon is "" then set theIcon to my reminderIcon(theApplication)
	return {theText:theText, theDate:theDate, valid:valid, theList:theList, theApplication:theApplication, theIcon:theIcon}
end parseReminder

on reminderIcon(theApplication)
	if theApplication is "" then
		return "unchecked.png"
	else
		set appinfo to my reminderApplicationInfo(theApplication, supportedReminderApplications)
		if appinfo is not missing value then
			return appinfo's icon
		else
			return "Instruments.png"
		end if
	end if
end reminderIcon

on formatReminderSubtitle(theText, theDate, theList, theApplication)
	if theApplication is not "" and not isAppSupported(theApplication, "Reminders") then
		return theApplication & " is not currently supported by this workflow"
	end if
	
	set subtitle to "Create a new reminder"
	if theApplication is not "" then set subtitle to subtitle & " from " & theApplication
	if theText is not "" then set subtitle to subtitle & " to " & theText
	if theDate is not "" then set subtitle to subtitle & " on " & (theDate as string)
	if theList is not "" then set subtitle to subtitle & " in " & quoted form of theList
	return subtitle
end formatReminderSubtitle

on reminderHelp()
	set theResult to {Â
		alfred_result_item_with_icon("reminder-help-1", "r all", "Show all outstanding reminders", "all", "no", "checked.png"), Â
		alfred_result_item_with_icon("reminder-help-2", "r refresh", "Refresh outstanding reminders", "refresh", "no", "checked.png"), Â
		alfred_result_item_with_icon("reminder-help-3", "r overdue", "Show overdue reminders", "overdue", "no", "checked.png"), Â
		alfred_result_item_with_icon("reminder-help-4", "r this", formatReminderSubtitle("", "", "", my frontmostapp()), "this", "no", "App.png") Â
			}
	set i to 5
	repeat with helpItem in reminderHelpItems
		set parsedReminder to my parseReminder(helpItem)
		set end of theResult to my alfred_result_item_with_icon("reminder-help-" & i, Â
			"r " & helpItem, Â
			formatReminderSubtitle(theText of parsedReminder, theDate of parsedReminder, theList of parsedReminder, theApplication of parsedReminder), Â
			helpItem, Â
			"no", Â
			"unchecked.png")
		set i to i + 1
	end repeat
	return theResult
end reminderHelp

on actionReminderQuery(q, shouldOpen, appLib, wf, cacheFile, defaultList)
	if q starts with "##DEL##" then
		set q to (characters 8 thru -1 of q) as string
		set shouldDelete to true
	else
		set shouldDelete to false
	end if
	if q starts with "uid:" then
		set theUID to (characters 5 thru -1 of q) as string
		try
			tell application id "com.apple.reminders"
				using terms from application "Reminders"
					set theReminder to (first item of (every reminder whose id is theUID))
					set theText to name of theReminder
					if shouldDelete then
						delete theReminder
						set theResult to "Deleted reminder: " & theText
					else if not shouldOpen then
						set completed of theReminder to true
						set theResult to "Completed reminder: " & theText
					else
						activate
						show theReminder
					end if
				end using terms from
			end tell
			my cacheReminders(wf, cacheFile)
		end try
	else
		set reminder to my parseReminder(q)
		set theText to theText of reminder
		set theDate to theDate of reminder
		set theApplication to theApplication of reminder
		set valid to valid of reminder
		set rList to theList of reminder
		set theBody to ""
		
		if valid is not "yes" then return "Could not understand command \"" & q & "\""
		
		if theApplication is not "" and isAppSupported(theApplication, "Reminders") then
			set theAppReminder to appLib's reminderFromApplication(theApplication)
			if theText is "" then
				set theText to theText of theAppReminder
			end if
			set theBody to theBody of theAppReminder
		else if theApplication is not "" then
			return theApplication & " is not currently supported by this workflow"
		end if
		
		tell application id "com.apple.reminders"
			using terms from application "Reminders"
				if rList is not "" then
					set theList to rList
				else if defaultList is not "" then
					set theList to defaultList
				else
					set theList to first list's name
				end if
				if theDate is not "" then
					tell list theList
						set theReminder to make new reminder with properties {name:theText, remind me date:theDate, body:theBody}
					end tell
				else
					tell list theList
						set theReminder to make new reminder with properties {name:theText, body:theBody}
					end tell
				end if
				if shouldOpen then
					activate
					show theReminder
				end if
			end using terms from
		end tell
		set osver to system version of (system info)
		if osver contains "10.9" then 
		set cacheReminders to false
		else
		set cacheReminders to true
		end
		if cacheReminders then my cacheReminders(wf, cacheFile)
		set theResult to "Created reminder: " & theText
	end if
	return theResult
end actionReminderQuery

on reminderApplicationInfo(appname, supportedReminderApplications)
	repeat with supportedApp in supportedReminderApplications
		if appname of supportedApp is appname then
			return supportedApp
		end if
	end repeat
	return missing value
end reminderApplicationInfo

-- notes specific

on setNotesActive()
	tell application "System Events"
		set notesIsRunning to (bundle identifier of processes) contains "com.apple.notes"
	end tell
	if notesIsRunning then
		set closeNotes to false
	else
		set closeNotes to true
	end if
end setNotesActive

on createNote(noteTitle, noteBody, notesFolder, notesAccount)
	tell application id "com.apple.Notes"
		using terms from application "Notes"
			if notesAccount is not "" then
				tell account notesAccount
					if notesFolder is not "" then
						tell folder notesFolder to make new note with properties {name:noteTitle, body:noteBody}
					else
						tell first folder to make new note with properties {name:noteTitle, body:noteBody}
					end if
				end tell
			else
				tell first account
					if notesFolder is not "" then
						tell folder notesFolder to make new note with properties {name:noteTitle, body:noteBody}
					else
						tell first folder to make new note with properties {name:noteTitle, body:noteBody}
					end if
					
				end tell
			end if
		end using terms from
	end tell
end createNote

on noteFromClipboard(q, notesFolder, notesAccount, wf)
	set noteHTMLText to my clipboardAsHTML(wf)
	if q is not "" then
		set noteTitle to q
	else
		set noteTitle to first paragraph of (the clipboard as string)
	end if
	createNote(noteTitle, noteHTMLText, notesFolder, notesAccount)
	return noteTitle
end noteFromClipboard

on clipboardAsHTML(wf)
	try
		set thex to (the clipboard as Çclass HTMLÈ)
		-- This will trigger an error if you've copied something other than HTML data
		set f to wf's get_cache() & "temp.html"
		-- Writes to a file named "temp.html" in cache
		set newFile to open for access POSIX file f with write permission
		set eof of newFile to 0
		write thex to newFile
		close access newFile
		set newFile to open for access POSIX file f
		set theHTML to read newFile as Çclass utf8È
		close access newFile
		return theHTML
	on error
		return "<pre>" & (the clipboard as Unicode text) & "</pre>"
	end try
end clipboardAsHTML

on formatNoteSubtitle(theText, notesAccount, notesFolder)
	set subtitle to "Create a new note about " & theText
	if notesFolder is not "" then set subtitle to subtitle & " in " & quoted form of notesFolder
	if notesAccount is not "" then set subtitle to subtitle & " in " & quoted form of notesAccount
	return subtitle
end formatNoteSubtitle

-- file metadata specific

on fileMeta(theFile, mediainfo, openmeta)
	set meta to my formatMediaInfo(mediainfo)
	set openmeta to my formatopenmeta(openmeta)
	if openmeta is not "" then set end of meta to openmeta
	set comment to my getSpotlightComment(theFile)
	if comment is not "" then
		set end of meta to my alfred_result_item("metadata-spotlightcomment", "Spotlight comment", comment, comment, "yes")
	end if
	return my alfred_result_items(meta)
end fileMeta

on formatMediaInfo(metadata)
	-- generate list of items
	set metadataProperties to {}
	repeat with i from 1 to number of paragraphs in metadata
		set this_item to paragraph i of metadata
		set this_data to my splitByColon(this_item)
		if item 1 of this_data is not "" and item 2 of this_data is not "" then
			if item 1 of this_data is "Complete name" then
				set metadataProperties to metadataProperties & {completename:{label:(item 1 of this_data), value:(item 2 of this_data), uid:"metadata-completename"}}
			else if item 1 of this_data is "Format" then
				set metadataProperties to metadataProperties & {format:{label:(item 1 of this_data), value:(item 2 of this_data), uid:"metadata-format"}}
			else if item 1 of this_data is "File size" then
				set metadataProperties to metadataProperties & {filesize:{label:(item 1 of this_data), value:(item 2 of this_data), uid:"metadata-filesize"}}
			else if item 1 of this_data is "Width" then
				set metadataProperties to metadataProperties & {width:{label:(item 1 of this_data), value:(item 2 of this_data), uid:"metadata-width"}}
			else if item 1 of this_data is "Height" then
				set metadataProperties to metadataProperties & {height:{label:(item 1 of this_data), value:(item 2 of this_data), uid:"metadata-height"}}
			else if item 1 of this_data is "Duration" then
				set metadataProperties to metadataProperties & {duration:{label:(item 1 of this_data), value:(item 2 of this_data), uid:"metadata-duration"}}
			else if item 1 of this_data is "Display aspect ratio" then
				set metadataProperties to metadataProperties & {aspectratio:{label:(item 1 of this_data), value:(item 2 of this_data), uid:"metadata-aspectratio"}}
			else if item 1 of this_data is "Frame rate" then
				set metadataProperties to metadataProperties & {framerate:{label:(item 1 of this_data), value:(item 2 of this_data), uid:"metadata-framerate"}}
			else if item 1 of this_data is "Color space" then
				set metadataProperties to metadataProperties & {colorspace:{label:(item 1 of this_data), value:(item 2 of this_data), uid:"metadata-colorspace"}}
			else if item 1 of this_data is "Chroma subsampling" then
				set metadataProperties to metadataProperties & {chromasubsampling:{label:(item 1 of this_data), value:(item 2 of this_data), uid:"metadata-chromasubsampling"}}
			else if item 1 of this_data is "Bit depth" then
				set metadataProperties to metadataProperties & {bitdepth:{label:(item 1 of this_data), value:(item 2 of this_data), uid:"metadata-bitdepth"}}
			else if item 1 of this_data is "Compression mode" then
				set metadataProperties to metadataProperties & {compressionmode:{label:(item 1 of this_data), value:(item 2 of this_data), uid:"metadata-compressionmode"}}
			else if item 1 of this_data is "Stream size" then
				set metadataProperties to metadataProperties & {streamsize:{label:(item 1 of this_data), value:(item 2 of this_data), uid:"metadata-streamsize"}}
			else if item 1 of this_data is "Language" then
				set metadataProperties to metadataProperties & {|language|:{label:(item 1 of this_data), value:(item 2 of this_data), uid:"metadata-language"}}
			end if
		end if
	end repeat
	
	-- format the list	
	set theResult to {}
	set metadataList to metadataProperties as list
	repeat with i from 1 to number of items in metadataList
		set this_item to item i of metadataList
		set end of theResult to my alfred_result_item(uid of this_item, label of this_item, value of this_item, value of this_item, "yes")
	end repeat
	return theResult
end formatMediaInfo

on formatopenmeta(metadata)
	-- generate list of items
	set metadataProperties to {}
	repeat with i from 1 to number of paragraphs in metadata
		set this_item to paragraph i of metadata
		set this_data to my splitByColon(this_item)
		if item 1 of this_data is not "" and item 2 of this_data is not "" then
			if item 1 of this_data is "tags" then
				set metadataProperties to metadataProperties & {tags:{label:"Tags", value:(item 2 of this_data), uid:"metadata-tags"}}
			else if item 1 of this_data is "rating" and item 2 of this_data is not "none found" then
				set metadataProperties to metadataProperties & {rating:{label:"Rating", value:(item 2 of this_data), uid:"metadata-rating"}}
			end if
		end if
	end repeat
	
	-- format the list	
	set theResult to {}
	set metadataList to metadataProperties as list
	repeat with i from 1 to number of items in metadataList
		set this_item to item i of metadataList
		set end of theResult to my alfred_result_item_with_icon(uid of this_item, label of this_item, value of this_item, value of this_item, "yes", "OpenMetaLogoIconOnly256.png")
	end repeat
	return theResult
end formatopenmeta

on getSpotlightComment(theFile)
	tell application id "com.apple.Finder"
		using terms from application "Finder"
			try
				return comment of (POSIX file theFile as alias)
			end try
		end using terms from
	end tell
end getSpotlightComment

-- alfred specific

on alfred_result(uid, title, subtitle, arg, valid)
	-- format the list	
	set theResult to alfred_result_items({my alfred_result_item(uid, title, subtitle, arg, valid)})
	return theResult
end alfred_result

on alfred_result_items(itemList)
	set theResult to "<?xml version=\"1.0\"?><items>"
	repeat with alfred_item in itemList
		set theResult to theResult & alfred_item
	end repeat
	set theResult to theResult & "</items>"
	return theResult
end alfred_result_items

on alfred_result_item(uid, title, subtitle, arg, valid)
	return my alfred_result_item_with_icon(uid, title, subtitle, arg, valid, "icon.png")
end alfred_result_item

on alfred_result_item_with_icon(uid, title, subtitle, arg, valid, icon)
	set theResult to "<item uid=\"" & uid & "\" arg=\"" & my q_encode(arg) & "\" type=\"file\" valid=\"" & valid & "\">"
	set theResult to theResult & "<title>" & my q_encode(title) & "</title>"
	set theResult to theResult & "<subtitle>" & my q_encode(subtitle) & "</subtitle>"
	set theResult to theResult & "<icon>" & icon & "</icon>"
	set theResult to theResult & "</item>"
	return theResult
end alfred_result_item_with_icon

on isAppSupported(appname, Workflow)
	if Workflow is "Reminders" then
		if my reminderApplicationInfo(appname, supportedReminderApplications) is not missing value then return true
	end if
	return false
end isAppSupported

-- check version

on alfred_version_notify(wfname, bundleid, currentversion, wf, cacheFile, checkFrequency)
	set notify to {}
	if not isLatestVersion(bundleid, currentversion, wf, cacheFile, checkFrequency) then
		set notify to alfred_result_item_with_icon(bundleid & "-update", "A new version of the " & wfname & " workflow is available", "Download the latest version", "@@UPDATE@@", true, "new.png")
	end if
	return notify
end alfred_version_notify

on isLatestVersion(bundleid, currentversion, wf, cacheFile, checkFrequency)
	try
		set timestamp to wf's get_value("updatecheck", cacheFile)
		set lastResult to wf's get_value("isLatestVersion", cacheFile)
		set lastVersion to wf's get_value("latestversion", cacheFile)
		set lastVersion to lastVersion as number
	end try
	
	if timestamp is not missing value and lastResult is not missing value and lastVersion is not missing value then
		if ((current date) - timestamp is less than checkFrequency) and lastVersion is less than or equal to currentversion then
			-- cache is still valid
			return true
		else if lastVersion is greater than currentversion then
			-- no need to check if we already know there's a newer version, regardless of age
			return false
		end if
	end if
	-- spawn cache process
	spawnReminderCache(workflowFolder & "/cache-update.scpt", true, bundleid & space & currentversion)
	return true
end isLatestVersion

on checkVersion(bundleid)
	set cmd to "curl --connect-timeout 5 -s " & updateURL & "?bundle=" & bundleid
	try
		return do shell script cmd
	end try
end checkVersion

-- this is performed as a last step, and so is ok to be slow
on getVersionURL(bundleid)
	set cmd to "curl --connect-timeout 5 -s " & downloadURL & "?bundle=" & bundleid
	try
		return do shell script cmd
	end try
end getVersionURL

-- general utility

on curlAddHeader(header)
	return " -H " & quoted form of header
end curlAddHeader

on curlAddData(theData)
	return " -d " & quoted form of theData
end curlAddData

on middleText(theText, startWord, endWord)
	set old_delims to AppleScript's text item delimiters
	set AppleScript's text item delimiters to space
	set itemList to text items of theText
	try
		set theResult to (items startWord thru endWord of itemList) as string
	on error
		set theResult to ""
	end try
	set AppleScript's text item delimiters to old_delims
	return theResult
end middleText

on convertTime(theTimeStr)
	set am to false
	set pm to false
	set num to 0
	try
		if theTimeStr is "noon" then set theTimeStr to "12pm"
		if theTimeStr is "midnight" then set theTimeStr to "12am"
		if (count of (characters of theTimeStr)) is greater than 1 then
			set old_delims to AppleScript's text item delimiters
			set AppleScript's text item delimiters to ""
			if characters -2 thru -1 of theTimeStr is {"a", "m"} then
				set theTimeStr to (characters 1 thru -3 of theTimeStr) as string
				set am to true
			else if characters -2 thru -1 of theTimeStr is {"p", "m"} then
				set theTimeStr to (characters 1 thru -3 of theTimeStr) as string
				set pm to true
			end if
			
			set AppleScript's text item delimiters to old_delims
		end if
		if (offset of "." in theTimeStr) is greater than 0 then
			-- check for form 1.30
			set theOffset to (offset of "." in theTimeStr)
			set num to num + ((text 1 thru (theOffset - 1) of theTimeStr) * hours)
			set num to num + ((text (theOffset + 1) thru -1 of theTimeStr) * minutes)
			if num is greater than or equal to (12 * hours) then
				set pm to true
			else
				set am to true
			end if
		else if (offset of ":" in theTimeStr) is greater than 0 then
			-- check for form 1:30
			set theOffset to (offset of ":" in theTimeStr)
			set num to num + ((text 1 thru (theOffset - 1) of theTimeStr) * hours)
			set num to num + ((text (theOffset + 1) thru -1 of theTimeStr) * minutes)
			if num is greater than or equal to (12 * hours) then
				set pm to true
			else
				set am to true
			end if
		else
			-- assume hours
			set num to num + (theTimeStr * hours)
		end if
		
		-- determine am or pm based on current time
		if (not am and not pm) Â
			and num is less than (12 * hours) Â
			and num is less than ((current date)'s time) then
			set pm to true
		else if num is greater than or equal to (12 * hours) then
			set num to (num - (12 * hours))
		end if
		
		if pm then
			set num to num + (12 * hours)
		end if
		
	on error
		return
	end try
	
	if num is less than ((current date)'s time) then
		--tomorrow
		set theDate to ((current date) + days)
	else
		--today
		set theDate to (current date)
	end if
	
	set theDate's time to num
	
	return theDate
	
end convertTime

on splitByColon(theText)
	set text1 to ""
	set text2 to ""
	try
		set pos to offset of ":" in theText
		if (pos) is greater than 0 then
			set text1 to text 1 thru (pos - 1) of theText
			set text2 to text (pos + 1) thru -1 of theText
			set text1 to my trim(true, text1)
			set text2 to my trim(true, text2)
		end if
	end try
	return {text1, text2}
end splitByColon

-- theseCharacters : A list of characters to trim
-- someText : The text to be trimmed
--
on trim(theseCharacters, someText)
	-- Lazy default (AppleScript doesn't support default values)
	if theseCharacters is true then set theseCharacters to Â
		{" ", tab, ASCII character 10, return, ASCII character 0}
	
	if someText is "" then return
	
	repeat until first character of someText is not in theseCharacters
		set someText to text 2 thru -1 of someText
	end repeat
	
	repeat until last character of someText is not in theseCharacters
		set someText to text 1 thru -2 of someText
	end repeat
	
	return someText
end trim

on echo(something)
	do shell script "echo " & quoted form of something
end echo

on format_date(the_date, format_string)
	-- store all elements of the date into variables
	set {year_num, month_num, day_num, hour_num, minute_num, second_num} to Â
		{year of the_date, (month of the_date) as integer, day of the_date, hours of the_date, Â
			minutes of the_date, seconds of the_date}
	set {month_name, day_name} to {(month of the_date) as string, (weekday of the_date) as string}
	set suffix_list to {"th", "st", "nd", "rd", "th", "th", "th", "th", "th", "th"}
	
	set placeholders to Â
		{"<<Year>>", Â
			"<<Year 2>>", Â
			"<<Century number>>", Â
			"<<Century>>", Â
			"<<Month>>", Â
			"<<Month 2>>", Â
			"<<Month name>>", Â
			"<<Day>>", Â
			"<<Day 2>>", Â
			"<<Day name>>", Â
			"<<Day suffix>>", Â
			"<<Hour>>", Â
			"<<Hour 2>>", Â
			"<<Minute>>", Â
			"<<Minute 2>>", Â
			"<<Second>>", Â
			"<<Second 2>>"}
	
	set value_list to {Â
		year_num as string, Â
		dd(year_num), Â
		(year_num div 100) as string, Â
		(year_num div 100 + 1) as string, Â
		month_num as string, Â
		dd(month_num), Â
		localized string of (month_name), Â
		day_num as string, Â
		dd(day_num), Â
		localized string of (day_name), Â
		item (day_num mod 10 + 1) of suffix_list, Â
		hour_num as string, Â
		dd(hour_num), Â
		minute_num as string, Â
		dd(minute_num), Â
		second_num as string, Â
		dd(second_num)}
	
	-- repace elements of format string
	set old_delims to AppleScript's text item delimiters
	-- in a loop, replace all placeholders by the
	-- values from value_list
	repeat with x from 1 to count placeholders
		set ph to item x of placeholders
		set val to item x of value_list
		set AppleScript's text item delimiters to ph
		set temp to every text item of format_string
		set AppleScript's text item delimiters to val as text
		set format_string to temp as text
	end repeat
	
	set AppleScript's text item delimiters to old_delims
	return format_string
end format_date

on datefromweekday(q)
	repeat with i from 1 to 7
		set d to (current date) + i * days
		set w to (weekday of d) as string
		if w is q then return d
	end repeat
	return false
end datefromweekday

on dd(the_num) -- double digits
	set the_val to (text -2 thru -1 of ((the_num + 100) as text)) as text
	return the_val
end dd

on coerceDateToNum(theDate)
	set {dDate, dDateNum} to {"1/1/1000", 364878}
	return (theDate - (date dDate)) div days + dDateNum
end coerceDateToNum

on unixtime(theDate)
	set epoch to current date
	set the month of epoch to 1
	set the day of epoch to 1
	set the year of epoch to 1970
	set the hours of epoch to 0
	set the minutes of epoch to 0
	set the seconds of epoch to 0
	(theDate - (epoch + (time to GMT)))
end unixtime

on frontmostapp()
	return name of (info for (path to frontmost application))
end frontmostapp

on filterRecords(recordList, searchProperty)
	set theResult to {}
	tell application "System Events"
		set theList to make new property list item with properties {value:recordList}
		set theValueList to value of (every property list item of (property list items of theList) whose name is searchProperty)
	end tell
	repeat with theItem in theValueList
		set the end of theResult to first item of theItem
	end repeat
	return theResult
end filterRecords

on q_is_empty(str)
	if str is missing value then return true
	return length of (my q_trim(str)) is 0
end q_is_empty

on q_trim(str)
	if class of str is not text or class of str is not string or str is missing value then return str
	if str is "" then return str
	
	repeat while str begins with " "
		try
			set str to items 2 thru -1 of str as text
		on error msg
			return ""
		end try
	end repeat
	repeat while str ends with " "
		try
			set str to items 1 thru -2 of str as text
		on error
			return ""
		end try
	end repeat
	return str
end q_trim

on q_encode(str)
	if class of str is not text or (my q_is_empty(str)) then return str
	set s to ""
	repeat with sRef in str
		set c to contents of sRef
		if c is in {"&", "'", "\"", "<", ">"} then
			if c is "&" then
				set s to s & "&amp;"
			else if c is "'" then
				set s to s & "&apos;"
			else if c is "\"" then
				set s to s & "&quot;"
			else if c is "<" then
				set s to s & "&lt;"
			else if c is ">" then
				set s to s & "&gt;"
			end if
		else
			set s to s & c
		end if
	end repeat
	return s
end q_encode

on path2url(thePath)
	return do shell script "python -c \"import urllib, sys; print (urllib.quote(sys.argv[1]))\" " & quoted form of thePath
end path2url

on keyDowntest(workflowPath, modifierKey) -- test for key down
	set modKeyDown to do shell script quoted form of (workflowPath & "/checkModifierKeys") & space & modifierKey
	set modKeyDown to modKeyDown as integer
	set modKeyDown to modKeyDown as boolean
end keyDowntest

on FileExists(theFile) -- (String) as Boolean
	tell application "System Events"
		if exists file theFile then
			return true
		else
			return false
		end if
	end tell
end FileExists