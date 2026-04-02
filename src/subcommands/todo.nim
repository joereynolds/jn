import std/[os, osproc, parsecfg, sequtils, strutils]

import ../config
import ../fuzzy
import ../grep

const aliases* = @["t", "todo", "task"]

proc process*(config: Config) =
  let matches = grep.search("^- \\[ \\]", config)
  # echo matches
  let lines = matches.mapIt(it.lineContent)

  var choice = selectFromChoice(lines, config)
