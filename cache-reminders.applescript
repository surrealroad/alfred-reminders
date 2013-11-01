property bundleid : "com.surrealroad.alfred-reminder"
property cacheFile : "cache.plist"

on run
	set myPath to path to me
	tell application "Finder" to set workflowFolder to (folder of myPath) as string
	set lib to load script file (workflowFolder & "alfred_library.scpt")
	set wf to load script file (workflowFolder & "q_workflow.scpt")
	
	set wf to wf's new_workflow_with_bundle(bundleid) --create folders and set up paths
	set cachePath to wf's _data & cacheFile
	
	try
		if wf's get_value("cacheInProgress", cacheFile) then
			-- prevent multiple cache processes overlapping
			return "Cache already in progress"
		end if
	end try
	
	wf's set_value("cacheInProgress", lib's unixtime(current date), cacheFile)
	
	try
		wf's get_value("reminderCount", cacheFile)
	on error
		wf's set_value("reminderCount", 0, cacheFile)
	end try
	
	set existingReminders to {}
	set didTimeout to false
	if (system version of (system info)) is "10.9" then
		set theTimeout to 600 --1000
	else
		set theTimeout to 100
	end if
	
	tell application id "com.apple.reminders"
		
		set reminderList to reminders whose (completed is false)
		
		set inTime to current date
		set i to 1
		repeat with reminder_item in reminderList
			set reminderRecord to {uid:reminder_item's id}
			set reminderRecord to reminderRecord & {title:reminder_item's name}
			if reminder_item's body is not missing value then set reminderRecord to reminderRecord & {notes:reminder_item's body}
			set reminderRecord to reminderRecord & {creationdate:reminder_item's creation date}
			if reminder_item's due date is not missing value then set reminderRecord to reminderRecord & {duedate:reminder_item's due date}
			if reminder_item's remind me date is not missing value then set reminderRecord to reminderRecord & {reminddate:reminder_item's remind me date}
			set reminderRecord to reminderRecord & {importance:reminder_item's priority}
			set reminderRecord to reminderRecord & {parentlist:(reminder_item's container's name)}
			
			--set end of existingReminders to reminderRecord
			--write out to plist
			try
				tell application "System Events"
					tell property list file cachePath
						tell contents
							make new property list item at end with properties {kind:record, name:"reminder" & i, value:reminderRecord}
						end tell
					end tell
				end tell
			on error eMsg number eNum
				return "Can't write plist: " & eMsg & " number " & eNum
			end try
			
			--update reminder count
			wf's set_value("reminderCount", i, cacheFile)
			
			set i to i + 1
			
			if ((current date) - inTime) is greater than theTimeout then
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
		wf's set_value("timestamp", (current date), cacheFile)
		wf's set_value("reminderCount", i - 1, cacheFile)
		wf's set_value("cacheInProgress", 0, cacheFile)
	on error errMsg
		return errMsg
	end try
	
	if didTimeout then return "timed out"
	return
end run