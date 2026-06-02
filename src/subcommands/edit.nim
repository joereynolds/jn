import std/[os, osproc, parsecfg, sequtils, strutils, sugar]

import ../config
import ../fuzzy/fuzzy

const name = "edit"

proc process*(config: Config, query: string) =
  var choice = selectFromDir(
    getNotesPath(config),
    config,
    query
  )

  choice.stripLineEnd()

  if choice == "": quit()

  let choices = choice.split("\0")
                      .map(c => c.strip())
                      .filterIt(it != "")

  let quotedFiles = choices.map(f => quoteShell(f)).join(" ")
  discard os.execShellCmd(getEditor() & " " & quotedFiles)
