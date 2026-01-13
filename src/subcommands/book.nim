import std/algorithm
import std/os

import ../config
import ../files

proc printNotesForBook(book: string) =
    let bookDir = getNotesLocation() & book
    var notes = getFilesForDir(bookDir)
    var lastPaths = @[""]

    for note in notes:
        lastPaths.add(lastPathPart(note))

    lastPaths.sort()

    for file in lastPaths:
        if file != "":
            echo file

proc process*(params: seq[string]) = 

    let book = params[0][1..^1]
    let remainingArgs = params[1..^1]

    if remainingArgs.len <= 0:
        printNotesForBook(book)

