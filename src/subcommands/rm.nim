import std/os
import std/strutils
import ../fuzzy

proc process*() = 
    var choice = makeSelection()

    choice.stripLineEnd()

    if choice == "":
        quit()

    removeFile(choice)
    echo "Deleted: ", choice
