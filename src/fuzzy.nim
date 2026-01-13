import config
import console
import files

import std/[os, osproc, streams, strutils]

proc makeSelection*(fromDir: string = getNotesLocation()): string =
    let notes = getFilesForDir(fromDir)
    let fuzzy = getFuzzyProvider()

    if findExe(fuzzy) == "":
        warn("Fuzzy finder " & fuzzy & " not installed on your system.")
        return

    let noteChoices = notes.join("\n")

    var p = startProcess(fuzzy, options = {poUsePath})

    p.inputStream.write(noteChoices)
    p.inputStream.close()

    var choice = p.outputStream.readAll()
    p.close()

    return choice
