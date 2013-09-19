alfred-reminders
================

This creates a new reminder in reminders.app
 
To use, just type "r reminder_text" into Alfred. E.g. "r check out some of Alfred's other workflows" to find an existing reminder with the search text, or to create a new one.
Actioning an existing reminder marks it as complete.
Hold option to view the new/existing reminder in Reminders.app, hold control to delete it.

To set a reminder for a specific date, use any of the following commands:
r today release the hamsters into the wild
r tomorrow bring about financial ruin upon my enemies
r in 5 minutes drop everything
r in 2 hours laugh out loud in random thoughts list
r in 3 days 1 hour pick stuff up off the floor
r on 24/12/13 to forget everything I know about things in movies
r on 12 June 15 to come up with some interesting ideas
r on 11 12 13 to check what the weather's like
r on 31-12-99 23:22 to panic about the millennium bug
r at 2pm to wait for nothing in particular
r thursday at 15.30 to ask some difficult questions

"r all" will show all current reminders
"r refresh" will show all current reminders and refresh the list

"r this" will capture the current application and turn it into a reminder

All sorts of combinations are possible!

"r help" will display the above examples

"r overdue" will display reminders which are overdue

The order of d/m/y (as well as HH:mm) I believe will depend on your region settings in the OS.
 
If you want to change the default reminder list, edit the applescript property at the top, otherwise it will just use the first one (unless you use "in Y list" at the end).
 
Changelog:

Wednesday, 18 September 2013 – Fix for non-english date format
Tuesday, 17 September 2013 – Updated q_workflow module to latest version
Thursday, 18 April 2013 – Fixed recognition of 10/11/12am/pm times
Tuesday, 16 April 2013 – Added support for WebKit nightly builds
Monday, 15 April 2013 – Added "r in x days y hours", "r in x hours y minutes", "r today/tomorrow/weekday at time to x" patterns
Thursday, 11 April 2013 – Added support for OmniFocus, Vienna, reminder from address book now adds a link to the contact
Wednesday, 10 April 2013 – Fix for -609 error (thanks, stevef!)
Tuesday, 9 April 2013 – Added "r refresh" keyword to refresh list ("r all" will no longer refresh the list); added "rshow", which will only show options for existing reminders, "radd", which will only show options for adding new reminders; added "rtest" which runs a set of tests to check for potential problems; fixed an issue that would cause workflow to crash (thanks, erist!)
Monday, 8 April 2013 – Better compatibility for editing library scripts on other systems; it's now possible to delete reminders by holding down control; fixed a rare issue where the workflow might incorrectly report a new version is available; iconography tweak; added "r overdue"; added support for TextMate and TextEdit; allow "r in 1 minute/hour/day"
Sunday, 7 April 2013 – Don't mark reminder as complete with option held down; properly escape illegal characters in query; added support for Finder and Chromium
Saturday, 6 April 2013 – Added "r this" which captures data from the current application and turns it into a reminder; support for Google Chrome, Safari, and Mail; fixed a regression; support for contacts/address book; added icons from the icon factory; "r all" now refreshes the cache
Friday, 5 April 2013 – Show "r all" in help; don't close reminders if its been moved to the foreground; all keywords can now be used to filter displayed reminders; changed the cache duration to 2 hours; subtitle for existing reminders shows more information where possible
Thursday, 4 April 2013 – Performance improvements; hold option to view the selected reminder in Reminders.app
Wednesday, 3 April 2013 – Fix for "in list" pattern breaking up text; added "r help" examples; don't prompt to create reminder with "all" keyword; checks for newer versions of the workflow
Tuesday, 2 April 2013 – If reminders.app is closed, it will stay closed when using this workflow
Sunday, 31 March 2013 – Added pattern "r Wednesday something"
Wednesday, 27 March 2013 – Renamed workflow to "Reminders"; Use application id instead of name, Alfred now shows existing reminders in his list (selecting one will mark it as complete); keyword is now optional
Tuesday, 26 March 2013 – Now sets specified date as the reminder date, rather than due date; added pattern "r something in Y list"
Wednesday, 20 March 2013 – You can now use the pattern "r at 1.30 to something"; Alfred will tell you what's going to happen before you press enter; split off code to library file
Tuesday, 19 March 2013 – You can now use the pattern "r in X minutes/hours/days something"
Sunday, 17 March 2013 – You can now specify a date for the reminder. See the examples above.

Uses AppleScript implementation of the Workflow object class for Alfred 2 (https://github.com/qlassiqa/qWorkflow)
Uses icons from the Flurry collection by David Lanham / The Icon Factory
