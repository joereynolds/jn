import std/os
import std/[osproc, parsecfg]
import std/strutils

import ../config
import ../fuzzy

const aliases* = @["e", "edit"]

proc process*(config: Config) =
  var choice = makeSelection(
    getNotesPath(config),
    config
  )

  choice.stripLineEnd()

  if choice == "":
    quit()

  discard os.execShellCmd(getEditor() & " " & quoteShell(choice))
