import std/algorithm
import std/os
import std/parsecfg

import ../config
import ../files

const aliases* = @["@book"]

proc printNotesForBook(config: Config, book: string) =
  let bookDir = getNotesPath(config) & book
  var notes = getFilesForDir(bookDir)
  var lastPaths = @[""]

  for note in notes:
    lastPaths.add(lastPathPart(note.name))

  lastPaths.sort()

  for file in lastPaths:
    if file != "":
      echo file

proc process*(config: Config, params: seq[string]) =
  let book = params[0][1 ..^ 1]
  let remainingArgs = params[1 ..^ 1]

  if remainingArgs.len <= 0:
    printNotesForBook(config, book)
