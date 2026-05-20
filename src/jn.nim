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
clCfg.noHelpHelp = true

let origRender = clCfg.render

clCfg.render = proc(s: string): string =
  result = if origRender != nil: origRender(s) else: s
  result = result.replace("EDITOR", "EDITOR (" & getEditor() & ")")

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
  "h": "help",
  "r": "recent",
  "re": "recent",
  "t": "todo",
  "template": "tmpl",
  "temp": "tmpl",
  "tm": "tmpl",
}.toTable()

proc mergeParams(cmdNames: seq[string], cmdLine = commandLineParams()): seq[string] =
  result = cmdLine
  if result.len > 0 and result[0] in @["h", "help"]:
    result[0] = "--help"
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
if paramCount() > 0 and params[0] notin subcommands and params[0] notin aliasMap and not params[0].startsWith("-"):
  fallback(params)
  quit()

# Everything else...
dispatchMulti(
  [catProxy,      cmdName = "cat",  positional = "query",   doc="Fuzzy search and print note"],
  [configProxy,   cmdName = "config",                       doc="Open config in EDITOR"],
  [editProxy,     cmdName = "edit", positional = "query",   doc="Fuzzy search and open note in EDITOR"],
  [grepProxy,     cmdName = "grep", positional = "query",   doc="Grep for term and fuzzy search to edit"],
  [lsProxy,       cmdName = "ls",                           doc="List all notes in your notes directory"],
  [mvProxy,       cmdName = "mv",   positional = "query",   doc="Fuzzy search and rename note"],
  [
    recentProxy,
    cmdName = "recent",
    help = {"limit": "The number of recent files to display"},
    doc = "Displays the 15 most recent files (also takes a --limit)"
  ],
  [rmProxy,       cmdName = "rm",   positional = "query",   doc="Fuzzy search and delete note"],
  [shareProxy,    cmdName = "share",                        doc="Share a note online. A permalink is given back (uses paste.rs, be respectful!)"],
  [starProxy,     cmdName = "star",                         doc="Mark a note as \"starred\""],
  [templateProxy, cmdName = "template",                     doc="Fuzzy search and edit template files"],
  [tagsProxy,     cmdName = "tags", positional = "query",   doc="Search for notes by tag (e.g. #vim)"],
  [todoProxy,     cmdName = "todo",                         doc="Fuzzy search all incomplete tasks and complete them"],
)

try:
  let validationResults = config.validate(configuration)
  for item in validationResults: echo item
except Exception as e:
  info(e.msg)
