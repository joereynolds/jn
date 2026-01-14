import std/os
import std/osproc
import std/parsecfg
import std/strutils

import ../config
import ../files
import ../grep/rg

const aliases* = @["/", "grep", "rg"]

proc process*(searchTerm: string, config: Config) =
  let notes = getFilesForDir(getNotesLocation(config))
  let fuzzy = getFuzzyProvider(config)
  let matches = rg.execute(searchTerm, config)

  if matches == "":
    echo "No matches, quitting"
    quit()

  var choice = execProcess("echo " & quoteShell(matches) & " | " & fuzzy)
  choice.stripLineEnd()

  if choice == "":
    quit()

  discard os.execShellCmd(getEditor() & " " & quoteShell(choice))
