{.push raises: [].}

import std/parsecfg
import std/envvars
import std/os
import std/times
import std/strutils


proc getConfigLocation*(): string =
    let directory = getEnv(
        "XDG_CONFIG_HOME",
        "blah"
    )

    return directory & "/jn/config.ini"

let configuration* = loadConfig(getConfigLocation())

proc validate*(config: Config = configuration) {.raises: [ValueError, KeyError].} =
    var errors: seq[string] = @[]
    
    let notesLocation = config.getSectionValue(
        "",
        "notes_location"
    )

    let notes_prefix = config.getSectionValue(
        "",
        "notes_prefix"
    )

    if not dirExists(expandTilde(notesLocation)):
        errors.add("The notes_location of " & notesLocation & " in your config does not exist")

    try:
        discard now().format(notes_prefix)
    except TimeFormatParseError:
        errors.add("The notes_prefix of " & notes_prefix & " in your config is an invalid date format")
    
    if errors.len > 0:
        raise (ref ValueError)(
            msg: errors.join("\n")
        )
    

proc getEditor*(): string =
    # TODO - first read from config
    # then env, then fallback
    return getEnv(
        "EDITOR",
        "vi"
    )

proc getFuzzyProvider*(): string = 
    # TODO - Read from config and fallback to fzf
    return "fzy"

proc getNotesLocation*(): string =
    # TODO - In here, first listen to config, then XDG_DOCUMENTS_DIR and then ~/Documents/
    return "~/Documents/work/"
