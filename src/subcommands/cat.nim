import std/[cmdline, os, parsecfg, strutils]
import ../config
import ../fuzzy

const name = "cat"
const aliases = @["c"]

proc process*(config: Config, query: string) =
  var query = commandLineParams()[1..^1].join(" ")

  var choice = selectFromDir(
    getNotesPath(config),
    config,
    query
  )

  choice.stripLineEnd()

  if choice == "":
    quit()

  let content = readFile(choice)
  echo content
