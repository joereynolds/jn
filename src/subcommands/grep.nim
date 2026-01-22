import std/os
import std/osproc
import std/parsecfg
import std/strutils

import ../config
import ../files
import ../grep

const aliases* = @["/", "grep"]

proc process*(searchTerm: string, config: Config) =
  if searchTerm.strip() == "":
    echo "Grep is missing the search string"
    quit()

  let notes = getFilesForDir(getNotesPath(config))
  let fuzzy = getFuzzyProvider(config)
  let matches = search(searchTerm, config)

  if matches == "":
    echo "No matches, quitting"
    quit()

  var choice = execProcess("echo " & quoteShell(matches) & " | " & fuzzy)
  choice.stripLineEnd()

  if choice == "":
    quit()

  discard os.execShellCmd(getEditor() & " " & quoteShell(choice))
