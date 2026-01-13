import std/os
import std/[osproc, paths, strutils]

import ../config
import ../templates
import ../fuzzy


proc process*() = 
    var choice = makeSelection($getTemplateLocation())
    
    choice.stripLineEnd()
    
    if choice == "":
        quit()
    
    discard os.execShellCmd(getEditor() & " " & quoteShell(choice))
