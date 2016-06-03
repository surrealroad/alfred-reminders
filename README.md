alfred-reminders
================

This creates a new reminder in reminders.app

Download the latest version, for Alfred v3 -> http://bit.ly/1UlcR8F

For Alfred v2 -> http://bit.ly/10uCE2J

More information at http://www.alfredforum.com/topic/917-reminders/
 
To use, just type "r reminder_text" into Alfred. E.g. "r check out some of Alfred's other workflows" to find an existing reminder with the search text, or to create a new one.
Actioning an existing reminder marks it as complete.
Hold option to view the new/existing reminder in Reminders.app, hold control to delete it.

To set a reminder for a specific date, use any of the following commands:
- r today release the hamsters into the wild
- r tomorrow bring about financial ruin upon my enemies
- r in 5 minutes drop everything
- r in 2 hours laugh out loud in random thoughts list
- r in 3 days 1 hour pick stuff up off the floor
- r on 24/12/13 to forget everything I know about things in movies
- r on 12 June 15 to come up with some interesting ideas
- r on 11 12 13 to check what the weather's like
- r on 31-12-99 23:22 to panic about the millennium bug
- r at 2pm to wait for nothing in particular
- r thursday at 15.30 to ask some difficult questions

"r all" will show all current reminders

"r refresh" will show all current reminders and refresh the list

"r this" will capture the current application and turn it into a reminder

All sorts of combinations are possible!

"r help" will display the above examples

"r overdue" will display reminders which are overdue

The order of d/m/y (as well as HH:mm) I believe will depend on your region settings in the OS.
 
If you want to change the default reminder list, edit the applescript property at the top, otherwise it will just use the first one (unless you use "in Y list" at the end).

Uses AppleScript implementation of the Workflow object class for Alfred 2 (https://github.com/qlassiqa/qWorkflow)

Uses icons from the Flurry collection by David Lanham / The Icon Factory

Uses Brati's Lover Property List Library (http://applescript.bratis-lover.net/library/plist/)
