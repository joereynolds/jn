import std/osproc
import std/strutils
import std/terminal

import ../config
import ../files
import std/dirs
import std/os
import std/paths
import std/symlinks

proc process*() = 

    discard existsOrCreateDir(
        Path(getNotesLocation() & "starred")
    )

    let notes = getNotes(getNotesLocation())
    let fuzzy = getFuzzyProvider()
    let noteChoices = quoteShell(notes.join("\n"))

    var choice = execProcess("echo " & noteChoices & " | " & fuzzy)

    choice.stripLineEnd()

    if choice == "":
        quit()

    let message = "Starred file " & choice
    let filename = extractFilename(choice)

    stdout.styledWriteLine(fgGreen, message)

    createSymlink(
        Path(choice),
        Path(getNotesLocation() & "starred" & DirSep & filename)
    )
