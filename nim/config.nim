import std/parsecfg
import std/envvars

proc getConfigLocation*(): string =
    let directory = getEnv(
        "XDG_CONFIG_HOME",
        "blah"
    )

    return directory & "/jn/config.ini"

let configuration* = loadConfig(getConfigLocation())

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
