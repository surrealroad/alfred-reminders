property cacheFile : missing value
property workflowFolder : missing value

on run argv
	set bundleid to item 1 of argv
	set currentversion to item 2 of argv
	set lib to load script file (workflowFolder & "alfred_library.scpt")
	set wf to load script file (workflowFolder & "q_workflow.scpt")
	
	set wf to wf's new_workflow_with_bundle(bundleid)
	
	wf's set_value("updatecheck", (current date), cacheFile)
	
	try
		set latestVersionInfo to lib's splitByColon(lib's checkVersion(bundleid))
		if item 1 of latestVersionInfo is "version" then set latestversion to (item 2 of latestVersionInfo) as number
		set isLatest to (currentversion is greater than or equal to latestversion)
	on error
		set isLatest to true
	end try
	
	wf's set_value("isLatestVersion", isLatest, cacheFile)
	wf's set_value("latestversion", latestversion, cacheFile)
	
	return
end run