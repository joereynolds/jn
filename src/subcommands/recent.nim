import std/[algorithm, parsecfg, times]
import ../[console, config, files]

const aliases* = @["r", "re", "recent"]

proc process*(config: Config, flags: seq[string]) =

  let notes = getFilesforDir(getNotesPath(config))
  let byTime = notes.sortedByIt(it.modifiedTime).reversed()

  # TODO - use --limit flag here
  for note in byTime[0 .. 15]:
    stdout.write(note.name)
    info("(" & $note.modifiedTime & ")")

  
