import std/[algorithm, os, parsecfg, paths, strutils, tables, times]
import categories, config, console, templates

type DirectoryListing = Table[string, int]

proc getFullNotePath*(note: string, config: Config, book: string = ""): Path =
  let suffix = getNotesSuffix(config)
  let dateFormat = getNotesPrefix(config)
  let prefix = now().format(dateFormat)
  let location = config.getNotesPath()

  let baseLocation = 
    if book != "":
      expandTilde(location) / book
    else:
      expandTilde(location)
  
  let fullName = baseLocation / (prefix & "-" & note.replace(" ", "-") & suffix)

  return Path(fullName)

proc createNote*(noteName: string, config: Config, book: string = "") =
  if book != "":
    let bookDir = expandTilde(config.getNotesPath()) / book
    discard existsOrCreateDir(bookDir)
  
  let name = getFullNotePath(noteName, config, book)
  let shouldGetTemplate = true # TODO - Make sure to read flags for --no-template

  if shouldGetTemplate:
    for myTemplate in getTemplates(config):
      if string(name).contains(myTemplate.titleContains):
        myTemplate.process(name, config)
        break

  let exitCode = os.execShellCmd(getEditor() & " " & $name)
  let message = "Created " & $name

  if exitCode == 0:
    success(message)

    for category in getCategories(config):
      if string(name).contains(category.titleContains):
        category.process(name, config)
        break

proc getFilesForDir*(dir: string): seq[string] =
  var files = @[""]

  for file in walkDirRec(expandTilde(dir), yieldFilter = {pcFile, pcLinkToFile}):
    files.add(file)
  return files

proc getDirectories*(notesDir: string): DirectoryListing =
  var directories = initTable[string, int]()

  directories["."] = 0

  # Get all directories
  for kind, path in walkDir(expandTilde(notesDir)):
    if kind == pcFile:
      directories["."] += 1

    let pathAsKey = lastPathPart(path)
    if kind == pcDir and not isHidden(path):
      directories[pathAsKey] = 0

      # and count all notes
      for file in walkDirRec(path, yieldFilter = {pcFile, pcLinkToFile}):
        directories[pathAsKey] += 1

  return directories

proc printDirectories*(directories: DirectoryListing) =
  var sortedDirs: seq[string] = @[]

  for directory in directories.keys:
    sortedDirs.add(directory)

  sortedDirs.sort()

  for directory in sortedDirs:
    let fileCount = directories[directory]
    let noteCount = " (" & $fileCount & " notes" & ")"

    stdout.write(directory)
    info(noteCount)
