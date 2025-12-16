import std/os

import ../config


proc getCommand*(searchTerm: string): string =
    let location = os.expandTilde(getNotesLocation())
    return "rg '" & searchTerm & "' '" & location & "' --files-with-matches"
