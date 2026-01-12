import std/strutils

import ../config
import ../fuzzy
import ../console
import std/dirs
import std/os
import std/paths
import std/symlinks

proc process*() = 

    discard existsOrCreateDir(
        Path(getNotesLocation() & "starred")
    )

    var choice = makeSelection()

    choice.stripLineEnd()

    if choice == "":
        quit()

    let message = "Starred file " & choice
    let filename = extractFilename(choice)

    success(message)

    createSymlink(
        Path(choice),
        Path(getNotesLocation() & "starred" & DirSep & filename)
    )
