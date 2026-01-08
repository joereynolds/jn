import config
import files

import std/[osproc, streams, strutils]

proc makeSelection*(): string =
    let notes = getNotes(getNotesLocation())
    let fuzzy = getFuzzyProvider()
    let noteChoices = notes.join("\n")

    var p = startProcess(fuzzy, options = {poUsePath})

    p.inputStream.write(noteChoices)
    p.inputStream.close()

    var choice = p.outputStream.readAll()
    p.close()

    return choice
