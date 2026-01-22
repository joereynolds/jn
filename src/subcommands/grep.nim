import std/os
import std/osproc
import std/parsecfg
import std/strutils

import ../fuzzy
import ../config
import ../grep

const aliases* = @["/", "grep"]

proc process*(searchTerm: string, config: Config) =
  if searchTerm.strip() == "":
    echo "Grep is missing the search string"
    quit()

  let matches = search(searchTerm, config)

  if matches == @[]:
    echo "No matches, quitting"
    quit()

  var choice = selectFromChoice(matches, config)

  choice.stripLineEnd()

  if choice == "":
    quit()

  discard os.execShellCmd(getEditor() & " " & quoteShell(choice))
