{.push raises: [].}

import std/[envvars, os, paths]


proc getTemplateLocation*(): string =

    var fallback = os.expandTilde("~")
    const idealFallback = os.expandTilde("~/.local/share/")

    if dirExists(idealFallback):
        fallback = idealFallback

    let directory = getEnv("XDG_DATA_HOME", fallback)

    return os.expandTilde(directory) & "/jn"

proc parse*(templatePath: Path): string {.raises: [IOError].} =
    if fileExists($templatePath):
        return readFile($templatePath)
    ""
