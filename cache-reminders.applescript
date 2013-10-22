property bundleid : "com.surrealroad.alfred-reminder"
property cacheFile : "cache.plist"

on run
	set myPath to path to me
	tell application "Finder" to set workflowFolder to (folder of myPath) as string
	set lib to load script file (workflowFolder & "alfred_library.scpt")
	set wf to load script file (workflowFolder & "q_workflow.scpt")
	set _plist to load script file (workflowFolder & "_plist.scpt")
	
	set wf to wf's new_workflow_with_bundle(bundleid) --create folders and set up paths
	set cachePath to wf's _data & cacheFile
	
	if lib's FileExists(cachePath) then
		try
			set cacheInProgress to _plist's readKey(cachePath, "cacheInProgress")
			-- prevent multiple cache processes overlapping
			if cacheInProgress then
				return "Cache already in progress"
			end if
		end try
	end if
	
	--create a new file
	_plist's newPlist(cachePath)
	
	--check keys exist
	try
		_plist's setKey(cachePath, "cacheInProgress", (lib's unixtime(current date)))
	on error
		_plist's addKey(cachePath, "cacheInProgress", (lib's unixtime(current date)))
	end try
	try
		_plist's readKey(cachePath, "timestamp")
	on error
		_plist's addKey(cachePath, "timestamp", (current date))
	end try
	(*try
		_plist's readKey(cachePath, "existingReminders")
	on error
		_plist's addKey(cachePath, "existingReminders", {})
	end try*)
	try
		_plist's readKey(cachePath, "reminderCount")
	on error
		_plist's addKey(cachePath, "reminderCount", 0)
	end try
	
	set existingReminders to {}
	set didTimeout to false
	
	tell application id "com.apple.reminders"
		
		set reminderList to reminders whose (completed is false)
		
		set inTime to current date
		repeat with reminder_item in reminderList
			set reminderRecord to {uid:reminder_item's id}
			set reminderRecord to reminderRecord & {title:reminder_item's name}
			if reminder_item's body is not missing value then set reminderRecord to reminderRecord & {notes:reminder_item's body}
			set reminderRecord to reminderRecord & {creationdate:reminder_item's creation date}
			if reminder_item's due date is not missing value then set reminderRecord to reminderRecord & {duedate:reminder_item's due date}
			if reminder_item's remind me date is not missing value then set reminderRecord to reminderRecord & {reminddate:reminder_item's remind me date}
			set reminderRecord to reminderRecord & {importance:reminder_item's priority}
			set reminderRecord to reminderRecord & {parentlist:(reminder_item's container's name)}
			
			set end of existingReminders to reminderRecord
			
			if ((current date) - inTime) is greater than 100 then
				set didTimeout to true
				exit repeat
			end if
			delay 0.01 -- this delay is important to prevent random "Connection is Invalid -609" AppleScript errors
		end repeat
		try
			set closeReminders to _plist's readKey(cachePath, "closeReminders")
		on error
			set closeReminders to missing value
		end try
		if closeReminders is not missing value and closeReminders Â
			and bundle identifier of (info for (path to frontmost application)) is not "com.apple.reminders" then
			quit
		end if
		
	end tell
	
	try
		_plist's setKey(cachePath, "timestamp", (current date))
		_plist's setKey(cachePath, "reminderCount", count of existingReminders)
		my plistDictFromArray(cachePath, "reminder", existingReminders)
		_plist's setKey(cachePath, "cacheInProgress", 0)
	on error errMsg
		return errMsg
	end try
	
	if didTimeout then return "timed out"
	return
end run

--convert a list to a dict
on plistDictFromArray(posixPath, prefix, theList)
	try
		tell application "System Events"
			tell property list file posixPath
				tell contents
					set i to 1
					repeat with theItem in theList
						make new property list item at end with properties {kind:record, name:prefix & i, value:theItem}
						set i to i + 1
					end repeat
				end tell
			end tell
		end tell
	on error eMsg number eNum
		error "Can't setPlistArray: " & eMsg number eNum
	end try
end plistDictFromArray