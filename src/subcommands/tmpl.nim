import std/os
import std/[osproc, parsecfg, paths, strutils]

import ../config
import ../templates/templates
import ../fuzzy

const name = "tmpl"

proc process*(config: Config) =
  var choice = selectFromDir(
    $getTemplateLocation(config),
    config
  )

  choice.stripLineEnd()

  if choice == "":
    quit()

  discard os.execShellCmd(getEditor() & " " & quoteShell(choice))
