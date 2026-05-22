import std/[algorithm, options, parsecfg, paths, times]
import ../[config, console, files]

const name = "ls"


proc recentFiles(
  config: Config,
  limit: int = 15,
  fromFiles: seq[FileRecord]
): seq[FileRecord] =
  let byTime = fromFiles.sortedByIt(it.modifiedTime).reversed()

  return byTime[0 .. limit - 1]

proc printFiles(notes: seq[FileRecord]) =
  for note in notes:
    stdout.write(lastPathPart(Path(note.name)))

    let mtime = $note.modifiedTime.format("YYYY-MM-dd HH:mm:ss")
    info(" (" & mtime & ")")

proc process*(
  config: Config,
  recent: Option[int]
) =

  var allFiles = getFilesforDir(getNotesPath(config))
  var files = allFiles

  if recent.isSome:
    files = recentFiles(config, recent.get, allFiles)

  printFiles(files)
