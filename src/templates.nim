{.push raises: [].}

import std/[os, paths]

type
    Template* = object
        configKey*: string
        location*: Path
        titleContains*: string

proc getTemplateLocation*(): Path =
    return Path(getDataDir() / "jn")

proc getContent*(templatePath: Path): string {.raises: [IOError].} =
    if fileExists($templatePath):
        return readFile($templatePath)
    ""
