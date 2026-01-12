import std/os
import std/strutils
import std/terminal
import ../fuzzy

proc process*() = 
    var choice = makeSelection()

    choice.stripLineEnd()

    if choice == "":
        quit()

    removeFile(choice)
    let message = "Deleted " & choice
    stdout.styledWriteLine(fgGreen, message)
