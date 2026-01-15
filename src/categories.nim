{.push raises: [].}

import std/[parsecfg, paths, strutils]
import config

type Category* = object
  configKey*: string
  moveTo*: Path
  titleContains*: string

proc getCategories*(config: Config): seq[Category] {.raises: [KeyError].} =
  var categories: seq[Category] = @[]

  for section in config.sections():
    if section.startsWith("category"):
      var t = Category(
        configKey: section,
        titleContains: config.getSectionValue(section, keyTitleContains),
        moveTo: Path(config.getSectionValue(section, keyMoveTo))
      )
      categories.add(t)

  return categories
