import std/strutils
import ../fuzzy

proc process*() = 
    var choice = makeSelection()

    choice.stripLineEnd()

    if choice == "":
        quit()

    let content = readFile(choice)
    echo content
