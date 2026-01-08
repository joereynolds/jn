import std/[osproc, streams]
import std/strutils

import ../config
import ../files

proc process*() = 
    let notes = getNotes(getNotesLocation())
    let fuzzy = getFuzzyProvider()
    let noteChoices = notes.join("\n")

    var p = startProcess(fuzzy, options = {poUsePath})

    p.inputStream.write(noteChoices)
    p.inputStream.close()

    var choice = p.outputStream.readAll()
    p.close()

    choice.stripLineEnd()

    if choice == "":
        quit()

    let content = readFile(choice)
    echo content
