on reminderFromApplication(theApplication)
	set workflowFolder to do shell script "pwd"
	set theText to ""
	set theBody to ""
	if theApplication is "Google Chrome.app" then
		set applib to load script POSIX file (workflowFolder & "/app_GoogleChrome.scpt")
	else if theApplication is "Chromium.app" then
		set applib to load script POSIX file (workflowFolder & "/app_Chromium.scpt")
	else if theApplication is "Google Chrome Canary.app" then
		set applib to load script POSIX file (workflowFolder & "/app_GoogleChromeCanary.scpt")
	else if theApplication is "Safari.app" then
		set applib to load script POSIX file (workflowFolder & "/app_Safari.scpt")
	else if theApplication is "Webkit.app" then
		set applib to load script POSIX file (workflowFolder & "/app_Webkit.scpt")
	else if theApplication is "Mail.app" then
		set applib to load script POSIX file (workflowFolder & "/app_Mail.scpt")
	else if theApplication is "Address Book.app" or theApplication is "Contacts.app" then
		set applib to load script POSIX file (workflowFolder & "/app_Contacts.scpt")
	else if theApplication is "Finder.app" then
		set applib to load script POSIX file (workflowFolder & "/app_Finder.scpt")
	else if theApplication is "TextEdit.app" then
		set applib to load script POSIX file (workflowFolder & "/app_TextEdit.scpt")
	else if theApplication is "TextMate.app" then
		set applib to load script POSIX file (workflowFolder & "/app_TextMate.scpt")
	else if theApplication is "Vienna.app" then
		set applib to load script POSIX file (workflowFolder & "/app_Vienna.scpt")
	else if theApplication is "Omnifocus.app" then
		set applib to load script POSIX file (workflowFolder & "/app_OmniFocus.scpt")
	else if theApplication is "FoldingText.app" then
		set applib to load script POSIX file (workflowFolder & "/app_FoldingText.scpt")
	else if theApplication is "Microsoft OneNote.app" then
		set applib to load script POSIX file (workflowFolder & "/app_OneNote.scpt")
	else if theApplication is "Microsoft Word.app" then
		set applib to load script POSIX file (workflowFolder & "/app_MSWord.scpt")
	else if theApplication is "Microsoft PowerPoint.app" then
		set applib to load script POSIX file (workflowFolder & "/app_PowerPoint.scpt")
	else if theApplication is "Adobe Acrobat.app" then
		set applib to load script POSIX file (workflowFolder & "/app_AcrobatPro.scpt")
	end if	
	set theText to applib's getTitle()
	set theBody to applib's getBody()
	return {theText:theText, theBody:theBody}
end reminderFromApplication

