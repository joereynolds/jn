import std/osproc
import std/strutils

import ../config
import ../files

proc process*() = 
    let notes = getNotes(getNotesLocation())
    let fuzzy = getFuzzyProvider()
    var choice = execProcess("echo '" & notes.join("\n") & "' | " & fuzzy)
    choice.stripLineEnd()
    let content = readFile(choice)
    echo content
