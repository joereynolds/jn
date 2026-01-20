{.push raises: [].}


import std/[os, parsecfg, paths, re, strutils]
import ../config
import ./variables/[today, note as noteV, shell]


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

proc renderVariables*(templateContent: string, note: Path): string {.raises: [RegexError, OSError, IOError] .} =
  var content = templateContent.replace(re"{{\s*today\s*}}", today.process(note))
  content = content.replace(re"{{\s*note\s*}}", noteV.process(note))
  content = shell.process(content, note)
  return content

proc process*(myTemplate: Template, note: Path, config: Config) {.raises: [KeyError, OSError, IOError, RegexError].} =
  let templatePath = getTemplateLocation(config) / myTemplate.location
  let templateContent: string = getContent(templatePath)

  writeFile(
    $note,
    renderVariables(templateContent, note)
  )
