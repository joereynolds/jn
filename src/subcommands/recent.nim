import std/[algorithm, parsecfg, paths, times]
import ../[console, config, files]


proc process*(config: Config, limit: int = 15) =
  let notes = getFilesforDir(getNotesPath(config))
  let byTime = notes.sortedByIt(it.modifiedTime).reversed()

  for note in byTime[0 .. limit - 1]:
    stdout.write(lastPathPart(Path(note.name)))

    let mtime = $note.modifiedTime.format("YYYY-MM-dd HH:mm:ss")
    info(" (" & mtime & ")")
