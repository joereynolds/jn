import std/os
import std/[osproc, parsecfg, paths, sequtils, strutils, sugar]

import ../config
import ../templates/templates
import ../fuzzy/fuzzy

const name = "template"

proc process*(config: Config) =
  var choice = selectFromDir(
    $getTemplateLocation(config),
    config
  )

  choice.stripLineEnd()

  if choice == "":
    quit()

  let choices = choice.split("\0")
                      .map(c => c.strip())
                      .filterIt(it != "")

  let quotedFiles = choices.map(f => quoteShell(f)).join(" ")
  discard os.execShellCmd(getEditor() & " " & quotedFiles)
