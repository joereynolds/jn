import std/[cmdline, dirs, os, parsecfg, paths, sequtils, strutils, sugar, symlinks]

import ../config
import ../fuzzy/fuzzy
import ../console

const name = "star"

proc process*(config: Config) =
  var query = commandLineParams()[1..^1].join(" ")

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
    createSymlink(Path(choice), Path(getNotesPath(config) & "starred" & DirSep & filename))

    let message = "Starred file " & choice
    success(message)
