import std/[os, osproc, parsecfg, strutils, tables]

import ../fuzzy/fuzzy
import ../config
import ../grep

const name = "grep"

proc reduceToAscii(input: string): string =
  result = ""
  for c in input:
    if c.ord in 32..126:
      result.add(c)

proc process*(config: Config, searchTerm: string) =
  if searchTerm.strip() == "":
    echo "Grep is missing the search string"
    quit()

  let matches = search(searchTerm, config)

  if matches == @[]:
    echo "No matches, quitting"
    quit()

  var displayChoices: seq[string] = @[]
  var matchLookup = initTable[string, Match]()

  for match in matches:
    let lineDisplay = reduceToAscii(match.lineContent).substr(0, 50) & "..."
    let key = match.file & " " & $match.lineNumber & ":" & lineDisplay
    displayChoices.add(key)
    matchLookup[key] = match

  var choice = selectFromChoice(displayChoices, config)
  choice.stripLineEnd()
  choice = choice.replace("\0", "")

  if choice == "":
    quit()

  let matchedLookup = matchLookup[choice]

  discard os.execShellCmd(getEditor() & " " & quoteShell(matchedLookup.file))
