{.push raises: [].}

import std/[envvars, os, paths]


proc getTemplateLocation*(): string =
    return getDataDir() / "jn"

proc getContent*(templatePath: Path): string {.raises: [IOError].} =
    if fileExists($templatePath):
        return readFile($templatePath)
    ""
