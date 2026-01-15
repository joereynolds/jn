import std/[osproc, parsecfg]

import ../config

proc getCommand*(searchTerm: string, config: Config): string =
  let location = getNotesPath(config)
  return "rg '" & searchTerm & "' '" & location & "' --files-with-matches"

proc execute*(command: string, config: Config): string =
  let command = getCommand(command, config)
  let output = osproc.execProcess(command)
  return output
