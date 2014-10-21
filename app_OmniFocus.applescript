on getTitle()
	tell application "OmniFocus" -- v1 & v2
		using terms from application "OmniFocus"
			tell content of first document window of front document
				--Get selection
				set validSelectedItemsList to value of (selected trees where class of its value is not item and class of its value is not folder)
				return name of first item of validSelectedItemsList
			end tell
		end using terms from
	end tell
end getTitle
on getBody()
	tell application "OmniFocus" -- v1 & v2
		using terms from application "OmniFocus"
			tell content of first document window of front document
				--Get selection
				set validSelectedItemsList to value of (selected trees where class of its value is not item and class of its value is not folder)
				return "omnifocus:///task/" & id of first item of validSelectedItemsList
				--return selection
			end tell
		end using terms from
	end tell
end getBody