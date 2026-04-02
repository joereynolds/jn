import std/[os, osproc, parsecfg, strutils, sequtils]

import ../fuzzy
import ../config
import ../grep

const aliases* = @["/", "grep"]

proc process*(searchTerm: string, config: Config) =
  if searchTerm.strip() == "":
    echo "Grep is missing the search string"
    quit()

  let matches = search(searchTerm, config)
  let fileNames = matches.mapIt(it.file)

  if matches == @[]:
    echo "No matches, quitting"
    quit()

  var choice = selectFromChoice(fileNames, config)

  choice.stripLineEnd()

  if choice == "":
    quit()

  discard os.execShellCmd(getEditor() & " " & quoteShell(choice))
