import std/[cmdline, os, osproc, parsecfg, strutils]

import ../config
import ../fuzzy

const aliases* = @["e", "edit"]

proc process*(config: Config, query: string) =
  var choice = selectFromDir(
    getNotesPath(config),
    config,
    query
  )

  choice.stripLineEnd()

  if choice == "":
    quit()

  discard os.execShellCmd(getEditor() & " " & quoteShell(choice))
