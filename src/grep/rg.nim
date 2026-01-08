import std/osproc

import ../config


proc getCommand*(searchTerm: string): string =
    let location = getNotesLocation()
    return "rg '" & searchTerm & "' '" & location & "' --files-with-matches"

proc execute*(command: string): string = 
    let command = getCommand(command)
    let output = osproc.execProcess(command)
    return output
