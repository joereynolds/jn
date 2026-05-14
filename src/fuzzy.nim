import config
import console
import files

import std/[os, osproc, parsecfg, sequtils, streams, strutils]

proc formatForFuzzy(matches: seq[string]): string =
  matches.join("\n")

proc getSelectionFromFuzzy(
  choices: seq[string],
  fuzzy: string,
  query: string = ""
): string =
  var p = startProcess(
    fuzzy,
    # TODO - this will break on any fuzzy finders
    # that don't support --query (thankfully fzy and fzf do)
    args = ["--query", query],
    options = {poUsePath}
  )

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

proc selectFromChoice*(
  choices: seq[string],
  config: Config,
  query: string = ""
): string =
  let fuzzy = getFuzzyProvider(config)

  if hasWarnedAboutNoFuzzy(fuzzy):
    return

  return getSelectionFromFuzzy(choices, fuzzy, query)

proc selectFromDir*(
  fromDir: string,
  config: Config,
  query: string = ""
): string =
  let choices = getFilesForDir(fromDir)

  return selectFromChoice(
    choices.mapIt(it.name),
    config,
    query
  )
