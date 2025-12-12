import std/envvars

proc get_config_dir*(): string =
    return getEnv(
        "XDG_CONFIG_HOME",
        "penis"
    )

proc get_editor(): string =
    # TODO - first read from config
    # then env, then fallback
    return getEnv(
        "EDITOR",
        "vi"
    )

proc get_fuzzy_provider(): string = 
    # TODO - Read from config and fallback to fzf
    return "fzy"

proc get_notes_location(): string =
    # TODO - In here, first listen to config, then XDG_DOCUMENTS_DIR and then ~/Documents/
    return "blah"
