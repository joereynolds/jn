{.push raises: [].}

import std/[os, parsecfg, paths, strutils]
import console, config

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

proc process*(category: Category, note: Path, config: Config) =
  try:
    let destination = Path(config.getNotesPath()) / category.moveTo / lastPathPart(note)
    moveFile(
      $note,
      $destination
    )
    success("Category detected, moved to " & $destination)
  except Exception:
    warn(getCurrentExceptionMsg())
