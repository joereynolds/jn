import std/os
import std/strutils
import ../fuzzy
import ../console

proc process*() = 
    var choice = makeSelection()

    choice.stripLineEnd()

    if choice == "":
        quit()

    removeFile(choice)
    let message = "Deleted " & choice
    success(message)
