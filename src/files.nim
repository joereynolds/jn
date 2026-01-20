import std/[algorithm, os, parsecfg, paths, strutils, tables, times]
import categories, config, console, templates

type DirectoryListing = Table[string, int]

proc getFullNotePath*(note: string, config: Config, book: string = ""): Path =
  let suffix = getNotesSuffix(config)
  let dateFormat = getNotesPrefix(config)
  let prefix = now().format(dateFormat)
  let location = config.getNotesPath()
  let fileName = prefix & "-" & note.replace(" ", "-") & suffix

  let baseLocation = 
    if book != "":
      expandTilde(location) / book
    else:
      expandTilde(location)
  
  var categoryPath = ""
  for category in getCategories(config):
    for title in category.titleContains.split(","):
      if fileName.toLowerAscii().contains(title.toLowerAscii()):
        categoryPath = $category.moveTo
        break
  
  let fullName = 
    if categoryPath != "":
      baseLocation / categoryPath / fileName
    else:
      baseLocation / fileName

  return Path(fullName)

proc createNote*(noteName: string, config: Config, book: string = "") =
  if book != "":
    let bookDir = expandTilde(config.getNotesPath()) / book
    discard existsOrCreateDir(bookDir)
  
  let name = getFullNotePath(noteName, config, book)
  
  # Ensure the directory exists (in case a category path was determined)
  let noteDir = parentDir($name)
  discard existsOrCreateDir(noteDir)
  
  let shouldGetTemplate = true # TODO - Make sure to read flags for --no-template

  if shouldGetTemplate:
    for myTemplate in getTemplates(config):
      for title in myTemplate.titleContains.split(","):
        if string(name).contains(title):
          myTemplate.process(name, config)
          break

  let exitCode = os.execShellCmd(getEditor() & " " & $name)
  
  if exitCode == 0 and fileExists($name):
    let message = "Created " & $name
    success(message)

proc getFilesForDir*(dir: string, filter = {pcFile, pcLinkToFile}): seq[string] =
  result = @[]
  
  for kind, path in walkDir(dir):
    if path.isHidden(): # TODO - respect --hidden flag
      continue

    if kind in filter:
      result.add(path)
    
    if kind == pcDir:
      # Recursively add paths from subdirectories
      result.add(getFilesForDir(path, filter))

proc getDirectories*(dir: string): DirectoryListing =
  var directories = initTable[string, int]()

  directories["."] = 0

  # Get all directories
  for kind, path in walkDir(expandTilde(dir)):
    if kind == pcFile:
      directories["."] += 1

    let pathAsKey = lastPathPart(path)
    if kind == pcDir and not isHidden(path):
      directories[pathAsKey] = 0

      # and count all notes
      for file in walkDirRec(path, yieldFilter = {pcFile, pcLinkToFile}):
        if not isHidden(file):
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
