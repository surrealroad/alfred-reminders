alfred-reminders
================

This creates a new reminder in Reminders.app

Download the latest version, for Alfred v3 and macOS

More information at [Alfred Forums](http://www.alfredforum.com/topic/917-reminders/)

## Usage
To use, just type `r <some text>` into Alfred.

For example, `r check out some of Alfred's other workflows` will create a new reminder called "check out some of Alfred's other workflows". 

You can also include times and dates in the text and have Alfred set a reminder for that particular time.

`r this` will capture the current application and turn it into a reminder.

To set a reminder for a specific date, use any of the following commands:
- `r today release the hamsters into the wild`
- `r tomorrow bring about financial ruin upon my enemies`
- `r in 5 minutes drop everything`
- `r in 2 hours laugh out loud in random thoughts list`
- `r on 24/12/13 to forget everything I know about things in movies`
- `r on 12 June 15 to come up with some interesting ideas`
- `r on 31-12-99 23:22 to panic about the millennium bug`
- `r at 2pm to wait for nothing in particular`
- `r next thursday at 15.30 to ask some difficult questions`

`r help` will display the above examples

All sorts of combinations are possible!

### Configuration
If you want to change the default reminder list, edit the variables component at the top of the workflow, otherwise it will just use the first one (unless you use "in Y list" at the end).

## Acknowlegdements
Date parsing is done via [chrono.js](https://github.com/wanasit/chrono)

Uses icons from the Flurry collection by David Lanham / The Icon Factory
