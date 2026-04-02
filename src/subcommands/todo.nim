import std/[os, osproc, parsecfg, sequtils, strutils, tables, times]

import ../console
import ../config
import ../fuzzy
import ../grep
import ../files

const aliases* = @["t", "todo", "task"]

proc process*(config: Config) =
  let matches = grep.search("^- \\[ \\]", config)

  var displayChoices: seq[string] = @[]
  var matchLookup = initTable[string, Match]()

  for i, match in matches:
    let key = $i & " " & match.lineContent
    displayChoices.add(key)
    matchLookup[key] = match

  var choice = selectFromChoice(displayChoices, config)

  choice.stripLineEnd()

  let matchedFile = matchLookup[choice].file
  var matchedContent: string = matchLookup[choice].lineContent
  let matchedLineNumber = matchLookup[choice].lineNumber

  let today = now().format("YYYY-MM-dd")
  matchedContent.add(" " & today)

  writeToLine(
    matchedFile,
    matchedLineNumber,
    matchedContent.replace("[ ]", "[x]")
  )

  console.success(
    "Marked " & choice & " as complete (" & matchedFile & ")."
  )

