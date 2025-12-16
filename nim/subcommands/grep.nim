import std/osproc
import std/strutils

import ../config
import ../files
import ../grep/rg

proc process*(searchTerm: string) = 
    let notes = getNotes(getNotesLocation())
    let command = rg.getCommand(searchTerm)
    
    echo command
    # var choice = execProcess("echo '" & notes.join("\n") & "' | " & fuzzy)
    # choice.stripLineEnd()
    # let content = readFile(choice)
