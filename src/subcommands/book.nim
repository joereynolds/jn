import std/algorithm
import std/os
import std/parsecfg

import ../config
import ../files

const aliases* = @["@book"]

proc printNotesForBook(book: string, config: Config) =
  let bookDir = getNotesPath(config) & book
  var notes = getFilesForDir(bookDir)
  var lastPaths = @[""]

  for note in notes:
    lastPaths.add(lastPathPart(note))

  lastPaths.sort()

  for file in lastPaths:
    if file != "":
      echo file

proc process*(params: seq[string], config: Config) =
  let book = params[0][1 ..^ 1]
  let remainingArgs = params[1 ..^ 1]

  if remainingArgs.len <= 0:
    printNotesForBook(book, config)
