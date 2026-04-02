import std/os
import std/[osproc, parsecfg]
import std/strutils

import ../config
import ../fuzzy
import ../grep

const aliases* = @["t", "todo", "task"]

proc process*(config: Config) =
  # var choice = selectFromDir(
  #   getNotesPath(config),
  #   config
  # )
  #
  # choice.stripLineEnd()
  #
  # if choice == "":
  #   quit()
  #
  # discard os.execShellCmd(getEditor() & " " & quoteShell(choice))

  let matches = grep.search("^- \\[ \\]", config)

  for match in matches:
    echo match
