import std/os
import std/osproc
import std/strutils

import ../config
import ../files

proc process*() = 
    let notes = getNotes(getNotesLocation())
    let fuzzy = getFuzzyProvider()
    var choice = execProcess("echo '" & notes.join("\n") & "' | " & fuzzy)
    choice.stripLineEnd()

    discard os.execShellCmd(getEditor() & " " & choice)
