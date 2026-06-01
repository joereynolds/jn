import std/[cmdline, os, parsecfg, sequtils, strutils, sugar]
import ../[config, console]
import ../fuzzy/fuzzy

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

  let choices = choice.split("\0")
                      .map(c => c.strip())
                      .filterIt(it != "")

  for choice in choices:
    # Don't print filename if we only have one result
    if choices.len > 1:
      info(choice)

    let content = readFile(choice)
    echo content
