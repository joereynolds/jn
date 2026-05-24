import std/[algorithm, options, parsecfg, paths, times, terminal]
import ../[config, console, files]

const name = "ls"
const dateFormat = "yyyy-MM-dd"

type DateComparison = enum
  Before
  After

proc recentFiles(
  config: Config,
  limit: int = 15,
  fromFiles: seq[FileRecord]
): seq[FileRecord] =
  let byTime = fromFiles.sortedByIt(it.modifiedTime).reversed()

  return byTime[0 .. limit - 1]

proc compareDate(
  date: string,
  fromFiles: seq[FileRecord],
  comparison: DateComparison,
): seq[FileRecord] =
  var datedNotes: seq[FileRecord] = @[]
  let targetDate = parse(date, dateFormat, utc())
  
  for note in fromFiles:

    let noteDate = parse(
      note.modifiedTime.format(dateFormat),
      dateFormat,
      utc()
    )

    let matches = case comparison
      of Before: noteDate <= targetDate
      of After: noteDate >= targetDate

    if matches:
      datedNotes.add(note)

  return datedNotes

proc printFiles(
  notes: seq[FileRecord],
  config: Config,
  noPrintDate: Option[bool],
) =
  for note in notes:

    let dir = relativePath(
      Path(note.name),
      Path(getNotesPath(config))
    )

    let name = lastPathPart(Path(note.name))

    stdout.styledWrite({styleDim}, $parentDir(Path(note.name)))
    stdout.write("/")

    if noPrintDate.isSome:
      stdout.writeLine($name)

    if noPrintDate.isNone:
      stdout.write($name)
      let mtime = note.modifiedTime.format("YYYY-MM-dd HH:mm:ss")
      info(" (" & mtime & ")")

proc process*(
  config: Config,
  recent: Option[int],
  after: Option[string],
  before: Option[string],
  noPrintDate: Option[bool]
) =

  var allFiles = getFilesforDir(getNotesPath(config))
  var files = allFiles

  if after.isSome:
    files = compareDate(after.get, allFiles, DateComparison.After)

  if before.isSome:
    files = compareDate(before.get, allFiles, DateComparison.Before)

  if recent.isSome:
    files = recentFiles(config, recent.get, allFiles)

  printFiles(files, config, noPrintDate)
