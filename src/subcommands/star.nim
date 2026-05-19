import std/[dirs, os, parsecfg, paths, strutils, symlinks]

import ../config
import ../fuzzy
import ../console

const aliases* = @["s", "star"]

proc process*(config: Config, query: string = "") =
  var query = query

  discard existsOrCreateDir(Path(getNotesPath(config) & "starred"))

  var choice = selectFromDir(
    getNotesPath(config),
    config,
    query
  )

  choice.stripLineEnd()

  if choice == "":
    quit()

  let message = "Starred file " & choice
  let filename = extractFilename(choice)

  success(message)

  createSymlink(Path(choice), Path(getNotesPath(config) & "starred" & DirSep & filename))
