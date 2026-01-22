import std/strutils

import ../config
import ../fuzzy
import ../console
import std/dirs
import std/os
import std/paths
import std/parsecfg
import std/symlinks

const aliases* = @["s", "star"]

proc process*(config: Config) =
  discard existsOrCreateDir(Path(getNotesPath(config) & "starred"))

  var choice = selectFromDir(
    getNotesPath(config),
    config
  )

  choice.stripLineEnd()

  if choice == "":
    quit()

  let message = "Starred file " & choice
  let filename = extractFilename(choice)

  success(message)

  createSymlink(Path(choice), Path(getNotesPath(config) & "starred" & DirSep & filename))
