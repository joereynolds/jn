import std/[parsecfg, strutils]
import ../config
import ../fuzzy

const aliases* = @["c", "cat"]

proc process*(config: Config, query: string = "") =
  var query = query

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
