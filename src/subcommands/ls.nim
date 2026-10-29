import std/[algorithm, options, parsecfg, times]
import ../[config, files]

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

  # Don't try and show more files than we have
  var limit = min(limit, byTime.len)

  return byTime[0 .. limit - 1]

proc staleFiles(
  config: Config,
  limit: int = 15,
  fromFiles: seq[FileRecord]
): seq[FileRecord] =
  let byTime = fromFiles.sortedByIt(it.modifiedTime)

  # Don't try and show more files than we have
  var limit = min(limit, byTime.len)

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

proc process*(
  config: Config,
  recent: Option[int],
  stale: Option[int],
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

  if stale.isSome:
    files = staleFiles(config, stale.get, allFiles)

  printFiles(files, config, noPrintDate)
