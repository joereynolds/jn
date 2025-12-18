import std/osproc
import std/strutils

import ../config
import ../files
import std/dirs
import std/paths

proc process*() = 

    discard existsOrCreateDir(
        Path(getNotesLocation() & "starred")
    )
