{.push raises: [].}


import std/[os, parsecfg, paths, strutils]
import config


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

proc getTemplates*(config: Config): seq[Template] {.raises: [KeyError].} =
  var templates: seq[Template] = @[]

  for section in config.sections():
    if section.startsWith("template"):
      var t = Template(
        configKey: section,
        titleContains: config.getSectionValue(section, keyTitleContains),
        location: Path(config.getSectionValue(section, keyUseTemplate)),
      )
      templates.add(t)

  return templates

proc process*(myTemplate: Template, note: Path, config: Config) {.raises: [KeyError, IOError].} =
  let templatePath = getTemplateLocation(config) / myTemplate.location
  let templateContent = getContent(templatePath)
  writeFile($note, templateContent)
