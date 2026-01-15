{.push raises: [].}

import std/parsecfg
import std/envvars
import std/os
import std/paths

import console, validators/[location, prefix]

const
  keyNoteLocation = "notes_location"
  keyNotePrefix = "notes_prefix"
  keyNoteSuffix = "notes_suffix"
  keyFuzzyProvider = "fuzzy_provider"
  keyUseTemplate* = "use_template"
  keyTitleContains* = "title_contains"
  keyMoveTo* = "move_to"
  boilerPlateConfigTemplate = staticRead("../config/config.ini")

proc getConfigLocation*(): string =
  getConfigDir() / "jn" / "config.ini"

proc getConfig*(filename: string): Config =
  try:
    return loadConfig(filename)
  except Exception:
    return newConfig()

proc getEditor*(): string =
  getEnv("EDITOR", "vi")

proc getFuzzyProvider*(config: Config): string {.raises: [KeyError].} =
  config.getSectionValue("", keyFuzzyProvider, "fzf")

proc getNotesSuffix*(config: Config): string {.raises: [KeyError].} =
  config.getSectionValue("", keyNoteSuffix, ".md")

proc getNotesPrefix*(config: Config): string {.raises: [KeyError].} =
  config.getSectionValue("", keyNotePrefix, "YYYY-MM-dd")

proc getDocumentsDir*(): string =
  getEnv("XDG_DOCUMENTS_DIR", "~/Documents/")

proc getNotesLocation*(config: Config): string {.raises: [KeyError].} =
  var notesLocation = config.getSectionValue(
    "",
    keyNoteLocation,
    getDocumentsDir() & "/jn"
  )

  if notesLocation[^1] != DirSep:
    notesLocation.add(DirSep)

  return expandTilde(notesLocation)

proc validate*(config: Config): seq[string] {.raises: [ValueError].} =
  var errors: seq[string] = @[]

  let locationErrors = validateLocation(getNotesLocation(config))
  if locationErrors != "": errors.add(locationErrors)

  let prefixErrors = validatePrefix(getNotesPrefix(config))
  if prefixErrors != "": errors.add(prefixErrors)

  return errors


proc existsOrCreateConfigDirectory() =
  let configDirectory = splitFile(getConfigLocation()).dir

  try:
    discard existsOrCreateDir(configDirectory)
  except IOError, OSError:
    warn("Failed to create config directory at " & configDirectory)

proc existsOrCreateNotesLocation(config: Config) = 
  try:
    discard existsOrCreateDir(getNotesLocation(config))
  except IOError, KeyError, OSError:
    
    try:
      warn("Failed to create notes location at " & getNotesLocation(config))
    except KeyError:
      warn("Failed to create notes location at the location in your config.")

proc existsOrCreateConfigFile() =
  let path = getConfigLocation()

  if not fileExists(path):
    try:
      writeFile(path, boilerPlateConfigTemplate)
      success("No config found, created one at " & path)
    except IOError, OSError:
      warn(
        "No config found, and could not create one. " & "Please create one manually at " &
          path
      )
      warn(getCurrentExceptionMsg())

proc createNecessaryDirectories*(config: Config) =
  existsOrCreateConfigDirectory()
  existsOrCreateConfigFile()
  existsOrCreateNotesLocation(config)
