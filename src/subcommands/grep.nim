import std/os
import std/osproc
import std/strutils

import ../config
import ../files
import ../grep/rg

proc process*(searchTerm: string) = 
    let notes = getNotes(getNotesLocation())
    let fuzzy = getFuzzyProvider()
    let matches = rg.execute(searchTerm)

    if matches == "":
        echo "No matches, quitting"
        quit()
    
    var choice = execProcess("echo " & quoteShell(matches) & " | " & fuzzy)
    choice.stripLineEnd()

    if choice == "":
        quit()

    discard os.execShellCmd(getEditor() & " " & quoteShell(choice))
