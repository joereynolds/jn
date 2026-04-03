import std/[os, osproc, parsecfg, strutils, tables]

import ../fuzzy
import ../config
import ../grep

const aliases* = @["/", "grep"]

proc process*(searchTerm: string, config: Config) =
  if searchTerm.strip() == "":
    echo "Grep is missing the search string"
    quit()

  let matches = search(searchTerm, config)

  var displayChoices: seq[string] = @[]
  var matchLookup = initTable[string, Match]()

  for match in matches:
    let key = match.file & " " & $match.lineNumber & ":" & match.lineContent.substr(0, 50) & "..."
    displayChoices.add(key)
    matchLookup[key] = match

  if matches == @[]:
    echo "No matches, quitting"
    quit()

  var choice = selectFromChoice(displayChoices, config)
  choice.stripLineEnd()

  let matchedLookup = matchLookup[choice]

  if choice == "":
    quit()

  discard os.execShellCmd(getEditor() & " " & quoteShell(matchedLookup.file))
