import std/parsecfg
import std/strutils
import ../config
import ../fuzzy

const aliases* = @["c", "cat"]

proc process*(config: Config) =
  var choice = makeSelection(
    getNotesLocation(config),
    config
  )

  choice.stripLineEnd()

  if choice == "":
    quit()

  let content = readFile(choice)
  echo content
