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
  discard existsOrCreateDir(Path(getNotesLocation(config) & "starred"))

  var choice = makeSelection(
    getNotesLocation(config),
    config
  )

  choice.stripLineEnd()

  if choice == "":
    quit()

  let message = "Starred file " & choice
  let filename = extractFilename(choice)

  success(message)

  createSymlink(Path(choice), Path(getNotesLocation(config) & "starred" & DirSep & filename))
