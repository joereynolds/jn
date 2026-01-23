import config
import console
import files

import std/[os, osproc, parsecfg, streams, strutils]

proc formatForFuzzy(matches: seq[string]): string =
  matches.join("\n")

proc getSelectionFromFuzzy(choices: seq[string], fuzzy: string): string =
  var p = startProcess(fuzzy, options = {poUsePath})

  let formattedChoices = formatForFuzzy(choices)

  p.inputStream.write(formattedChoices)
  p.inputStream.close()

  var choice = p.outputStream.readAll()
  p.close()

  return choice

proc hasWarnedAboutNoFuzzy(fuzzy: string): bool =
  if findExe(fuzzy) == "":
    warn("Fuzzy finder " & fuzzy & " not installed on your system.")
    warn("Try an alternative (fzf or fzy) for this command to work.")
    return true

proc selectFromChoice*(choices: seq[string], config: Config): string =
  let fuzzy = getFuzzyProvider(config)

  if hasWarnedAboutNoFuzzy(fuzzy):
    return

  return getSelectionFromFuzzy(choices, fuzzy)

proc selectFromDir*(fromDir: string, config: Config): string =
  let choices = getFilesForDir(fromDir)
  return selectFromChoice(choices, config)
