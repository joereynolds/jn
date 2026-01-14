import std/os
import std/[osproc, parsecfg, paths, strutils]

import ../config
import ../templates
import ../fuzzy

const aliases* = @["template", "temp", "tm"]

proc process*(config: Config) =
  var choice = makeSelection(
    $getTemplateLocation(config),
    config
  )

  choice.stripLineEnd()

  if choice == "":
    quit()

  discard os.execShellCmd(getEditor() & " " & quoteShell(choice))
