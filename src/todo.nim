import std/parsecfg
import ./[grep]

const incompleteTodoPattern*: string = "^- \\[ \\] "

proc getTodos*(config: Config): seq[Match] =
  getMatches(incompleteTodoPattern, config)
