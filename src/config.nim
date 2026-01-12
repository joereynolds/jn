{.push raises: [].}

import std/parsecfg
import std/terminal
import std/envvars
import std/os
import std/times
import std/strutils


proc getConfigLocation*(): string =

    var fallback = os.expandTilde("~")
    const idealFallback = os.expandTilde("~/.config")

    if dirExists(idealFallback):
        fallback = idealFallback

    let directory = getEnv(
        "XDG_CONFIG_HOME",
        fallback
    )

    return os.expandTilde(directory) & "/jn/config.ini"

let configDirectory = splitFile(getConfigLocation()).dir

if not dirExists configDirectory:
    try:
        createDir(configDirectory)
    except OSError as e:
        stdout.styledWriteLine(fgRed, e.msg)

if not fileExists(getConfigLocation()):
    try:
        copyFile("config/config.ini", getConfigLocation())
        stdout.styledWriteLine(
            fgGreen, 
            "No config found, created one at " & getConfigLocation()
        )
    except OSError:
        stdout.styledWriteLine(
            fgRed, 
            "No config found, and could not create one. " & 
            "Please create one manually at " & getConfigLocation()
        )

let configuration* = loadConfig(getConfigLocation())


proc getEditor*(): string =
    # TODO - first read from config
    # then env, then fallback
    return getEnv(
        "EDITOR",
        "vi"
    )

proc getFuzzyProvider*(config: Config = configuration): string {.raises: [KeyError].} =
    var fuzzyProvider = config.getSectionValue(
        "",
        "fuzzy_provider"
    )

    if fuzzyProvider == "":
        fuzzyProvider = "fzf"

    return fuzzyProvider

proc getNotesLocation*(config: Config = configuration): string {.raises: [KeyError].} =
    # TODO - In here, first listen to config, then XDG_DOCUMENTS_DIR and then ~/Documents/
    var notesLocation = config.getSectionValue(
        "",
        "notes_location"
    )

    if notesLocation[^1] != DirSep:
        notesLocation.add(DirSep)

    return expandTilde(notesLocation)

proc validate*(config: Config = configuration) {.raises: [ValueError].} =
    var errors: seq[string] = @[]
    
    let notesLocation = getNotesLocation()
    let notes_prefix = config.getSectionValue("", "notes_prefix")

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
