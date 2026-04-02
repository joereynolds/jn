import std/parsecfg
import ./[config, grep]

const incompleteTodoPattern*: string = "^- \\[ \\] "

proc getTodos*(config: Config): seq[Match] =
  getMatches(incompleteTodoPattern, config)
