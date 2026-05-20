import std/[os, strutils, tables]
import config
import console
import files

import cligen

import subcommands/[
  book, cat, config as sconfig, edit,
  grep, help, ls, mv, recent, rm,
  share, star, tags, todo, tmpl
]

clCfg.version = "1.2.0"

let configuration = getConfig(getConfigLocation())
let params = commandLineParams()
createNecessaryDirectories(configuration)

# TODO - hate this, can we use reflection to gather these?
# i.e. iterate through subcommands dir and grab all "name"s
const subcommands = [
  "cat", "config", "edit", "grep", "help", "ls", "mv",
  "recent", "rm", "share", "star", "tags", "todo", "tmpl"
]

const aliasMap = {
  "c": "cat",
  "conf": "config",
  "e": "edit",
  "/": "grep",
  "rg": "grep",
  "r": "recent",
  "re": "recent",
  "t": "todo",
  "template": "tmpl",
  "temp": "tmpl",
  "tm": "tmpl",
}.toTable()

proc mergeParams(cmdNames: seq[string], cmdLine = commandLineParams()): seq[string] =
  result = cmdLine
  if result.len > 0 and result[0] in aliasMap:
    result[0] = aliasMap[result[0]]

proc catProxy(query: seq[string] = @[]) = cat.process(configuration, query.join(" "))
proc configProxy() = sconfig.process(configuration)
proc editProxy(query: seq[string] = @[]) = edit.process(configuration, query.join(" "))
proc grepProxy(query: seq[string] = @[]) = grep.process(configuration, query.join(" "))
proc lsProxy() = ls.process(configuration)
proc mvProxy(query: seq[string] = @[], plain: bool = false) = mv.process(configuration, query.join(" "), plain)
proc recentProxy(limit: int = 15) = recent.process(configuration, limit)
proc rmProxy(query: seq[string] = @[]) = rm.process(configuration, query.join(" "))
proc shareProxy() = share.process(configuration)
proc starProxy() = star.process(configuration)
proc templateProxy() = tmpl.process(configuration)
proc tagsProxy(query: seq[string] = @[]) = tags.process(configuration, query.join(" "))
proc todoProxy(add: seq[string] = @[]) = todo.process(configuration, add.join(" "))

proc fallback(params: seq[string]) =
  var bookName = ""
  for param in params:
    if param.startsWith("@"):
      bookName = param[1..^1]  # Remove the @ prefix
      break

  files.createNote(params[0], configuration, bookName)

# Handles raw "jn" on its own
if paramCount() <= 0:
  info(configuration.getNotesPath())
  printDirectories(getDirectories(getNotesPath(configuration)))
  quit()

# Handle books "jn @vim" for example
if paramCount() > 0 and params[0].startsWith("@"):
  book.process(configuration, params)
  quit()

# Handle note creation, i.e. "jn 'my super cool note'"
if paramCount() > 0 and params[0] notin subcommands and params[0] notin aliasMap:
  fallback(params)
  quit()

# Everything else...
dispatchMulti(
  [catProxy, cmdName = "cat", positional = "query", doc="help goes here"],
  [configProxy, cmdName = "config", doc="help goes here"],
  [editProxy, cmdName = "edit", positional = "query", doc="help goes here"],
  [grepProxy, cmdName = "grep", positional = "query", doc="help goes here"],
  [lsProxy, cmdName = "ls", doc="help goes here"],
  [mvProxy, cmdName = "mv", positional = "query", doc="help goes here"],
  [recentProxy, cmdName = "recent", doc="help goes here"],
  [rmProxy, cmdName = "rm", positional = "query", doc="help goes here"],
  [shareProxy, cmdName = "share", doc="help goes here"],
  [starProxy, cmdName = "star", doc="help goes here"],
  [templateProxy, cmdName = "template", doc="help goes here"],
  [tagsProxy, cmdName = "tags", positional = "query", doc="help goes here"],
  [todoProxy, cmdName = "todo", doc="help goes here"],
)

try:
  let validationResults = config.validate(configuration)
  for item in validationResults: echo item
except Exception as e:
  info(e.msg)
