import std/os
import std/osproc
import std/strutils

import ../config
import ../files

proc process*() = 
    let notes = getNotes(getNotesLocation())
    let fuzzy = getFuzzyProvider()
    let noteChoices = quoteShell(notes.join("\n"))

    var choice = execProcess("echo " & noteChoices & " | " & fuzzy)

    choice.stripLineEnd()

    if choice == "":
        quit()

    discard os.execShellCmd(getEditor() & " " & quoteShell(choice))
