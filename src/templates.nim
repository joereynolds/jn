{.push raises: [].}

import std/[os, parsecfg, paths]

type Template* = object
  configKey*: string
  location*: Path
  titleContains*: string

proc getTemplateLocation*(config: Config): Path {.raises: [KeyError].} =
  let defaultLocation = getDataDir() / "jn"
  let location = config.getSectionValue("", "template_location", defaultLocation)
  return Path(location)

proc getContent*(templatePath: Path): string {.raises: [IOError].} =
  if fileExists($templatePath):
    return readFile($templatePath)
  ""
