import config
import console
import files

import std/[os, osproc, parsecfg, streams, strutils]

proc makeSelection*(fromDir: string, config: Config): string =
  let notes = getFilesForDir(fromDir)
  let fuzzy = getFuzzyProvider(config)

  if findExe(fuzzy) == "":
    warn("Fuzzy finder " & fuzzy & " not installed on your system.")
    warn("Try an alternative (fzf or fzy) for this command to work.")
    return

  let noteChoices = notes.join("\n")

  var p = startProcess(fuzzy, options = {poUsePath})

  p.inputStream.write(noteChoices)
  p.inputStream.close()

  var choice = p.outputStream.readAll()
  p.close()

  return choice
