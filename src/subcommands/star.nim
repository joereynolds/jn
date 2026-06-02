import std/[dirs, os, parsecfg, paths, sequtils, strutils, sugar, symlinks]

import ../config
import ../fuzzy/fuzzy
import ../console

const name = "star"

proc process*(config: Config, query: string) =
  discard existsOrCreateDir(Path(getNotesPath(config) & "starred"))

  var choice = selectFromDir(
    getNotesPath(config),
    config,
    query
  )

  let choices = choice.split("\0")
    .map(c => c.strip())
    .filterIt(it != "")

  for choice in choices:
    let filename = extractFilename(choice)
    let destination = Path(getNotesPath(config) & "starred" & DirSep & filename)

    if fileExists($destination):
      warn("Symlink for " & $destination & " already exists.")
      return

    createSymlink(
      Path(choice),
      destination
    )

    let message = "Starred file " & choice
    success(message)
