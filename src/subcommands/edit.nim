import std/os
import std/[osproc]
import std/strutils

import ../config
import ../fuzzy

proc process*() = 
    var choice = makeSelection()

    choice.stripLineEnd()

    if choice == "":
        quit()

    discard os.execShellCmd(getEditor() & " " & quoteShell(choice))
