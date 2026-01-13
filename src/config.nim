{.push raises: [].}

import std/parsecfg
import std/envvars
import std/os
import std/times
import std/strutils
import std/paths

import console
from templates import Template


const 
    keyNoteLocation = "notes_location"
    keyNotePrefix = "notes_prefix"
    keyNoteSuffix = "notes_suffix"
    keyFuzzyProvider = "fuzzy_provider"
    keyUseTemplate = "use_template"
    keyTitleContains = "title_contains"

proc getConfigLocation*(): string =
     getConfigDir() / "jn" / "config.ini"

let configDirectory = splitFile(getConfigLocation()).dir

discard existsOrCreateDir(configDirectory)

if not fileExists(getConfigLocation()):
    try:
        copyFile("config/config.ini", getConfigLocation())
        success("No config found, created one at " & getConfigLocation())
    except OSError:
        warn(
            "No config found, and could not create one. " & 
            "Please create one manually at " & getConfigLocation()
        )

let configuration* = loadConfig(getConfigLocation())


proc getEditor*(): string =
    getEnv("EDITOR", "vi")

proc getFuzzyProvider*(config: Config = configuration): string {.raises: [KeyError].} =
    config.getSectionValue("", keyFuzzyProvider, "fzf")

proc getNotesLocation*(config: Config = configuration): string {.raises: [KeyError].} =
    var notesLocation = config.getSectionValue(
        "",
        keyNoteLocation,
        getEnv("XDG_DOCUMENTS_DIR", "~/Documents/")
    )

    if notesLocation[^1] != DirSep:
        notesLocation.add(DirSep)

    return expandTilde(notesLocation)

proc getNotesSuffix*(config: Config = configuration): string {.raises: [KeyError].} =
    config.getSectionValue("", keyNoteSuffix, ".md")

proc validate*(config: Config = configuration) {.raises: [ValueError].} =
    var errors: seq[string] = @[]
    
    let notesLocation = getNotesLocation()
    let notesPrefix = config.getSectionValue("", keyNotePrefix)

    if not dirExists(os.expandTilde(notesLocation)):
        errors.add(
            "The notes_location of " & notesLocation & " in your config does not exist"
        )

    try:
        discard now().format(notes_prefix)
    except TimeFormatParseError:
        errors.add(
            "The notes_prefix of " & notes_prefix & " in your config is an invalid date format"
        )

    if errors.len > 0:
        raise (ref ValueError)(
            msg: errors.join("\n")
        )

proc getTemplates*(config: Config = configuration): seq[Template] {.raises: [KeyError].} =
    var templates: seq[Template] = @[]

    for section in config.sections():
        if section.startsWith("template"):
            var t = Template(
                configKey: section,
                titleContains: config.getSectionValue(section, keyTitleContains),
                location: Path(config.getSectionValue(section, keyUseTemplate))
            )
            templates.add(t)

    return templates
