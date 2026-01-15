{.push raises: [].}

import std/[os, parsecfg, paths, strutils]
import config

type Category* = object
  configKey*: string
  moveTo*: string
  titleContains*: string

proc getCategories*(config: Config): seq[Category] {.raises: [KeyError].} =
  var categories: seq[Category] = @[]

  for section in config.sections():
    if section.startsWith("category"):
      var t = Category(
        configKey: section,
        titleContains: config.getSectionValue(section, keyTitleContains),
        moveTo: config.getSectionValue(section, keyMoveTo),
      )
      categories.add(t)

  return categories

proc process*(category: Category, note: Path, config: Config) =
  try:
    moveFile(
      $note,
      config.getNotesLocation() / category.moveTo
    )
  except Exception:
    echo getCurrentExceptionMsg()
