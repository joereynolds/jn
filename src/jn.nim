import std/os
import std/strutils
import std/tables
import cligen

import config
import subcommands/[
  book, cat, config as sconfig, edit,
  grep, ls, mv, recent, rm,
  share, star, tags, todo, tmpl
]
import files
import console

const version = "1.1.2"

const aliasMap = {
  "c": "cat",
  "conf": "config",
  "e": "edit",
  "/": "grep",
  "rg": "grep",
  "h": "help",
  "move": "mv",
  "r": "recent",
  "re": "recent",
  "remove": "rm",
  "s": "star",
  "t": "todo",
  "task": "todo",
  "template": "tmpl",
  "temp": "tmpl",
  "tm": "tmpl",
  "tag": "tags",
}.toTable()

const knownSubcmds = [
  "cat", "config", "edit", "grep", "help", "ls", "mv",
  "recent", "rm", "share", "star", "tags", "todo", "tmpl"
]

# cligen hook — normalizes aliases before dispatch
proc mergeParams(cmdNames: seq[string], cmdLine = commandLineParams()): seq[string] =
  result = cmdLine
  if result.len > 0 and result[0] in aliasMap:
    result[0] = aliasMap[result[0]]

clCfg.version = version

let configuration = getConfig(getConfigLocation())

createNecessaryDirectories(configuration)

try:
  let validationResults = config.validate(configuration)
  for item in validationResults: echo item
except Exception as e:
  info(e.msg)

# Wrapper procs — Cmd suffix avoids naming conflicts with imported modules.
# seq[string] + positional lets multi-word queries like `jn cat my note` work.
proc catCmd(query: seq[string] = @[]) = cat.process(configuration, query.join(" "))
proc configCmd() = sconfig.process(configuration)
proc editCmd(query: seq[string] = @[]) = edit.process(configuration, query.join(" "))
proc grepCmd(searchTerm: seq[string] = @[]) = grep.process(searchTerm.join(" "), configuration)
proc lsCmd() = ls.process(configuration)
proc mvCmd(query: seq[string] = @[], plain = false) = mv.process(configuration, query.join(" "), plain)
proc recentCmd(limit = 15) = recent.process(configuration, limit)
proc rmCmd(query: seq[string] = @[]) = rm.process(configuration, query.join(" "))
proc shareCmd(query: seq[string] = @[]) = share.process(configuration, query.join(" "))
proc starCmd(query: seq[string] = @[]) = star.process(configuration, query.join(" "))
proc tagsCmd(tag: seq[string] = @[]) = tags.process(tag.join(" "), configuration)
proc todoCmd(add = "") = todo.process(configuration, add)
proc tmplCmd() = tmpl.process(configuration)

# These three cases cannot go through dispatchMulti:
#   1. No args — show the notes directory listing
#   2. @book   — special @ syntax cligen doesn't understand
#   3. Unknown non-flag word — create a new note
let params = commandLineParams()

if params.len == 0:
  info(configuration.getNotesPath())
  printDirectories(getDirectories(getNotesPath(configuration)))
  quit()

let cmd = params[0]

if cmd.startsWith("@"):
  book.process(params, configuration)
  quit()

let normalizedCmd = aliasMap.getOrDefault(cmd, cmd)
if not cmd.startsWith("-") and normalizedCmd notin knownSubcmds:
  var bookName = ""
  for param in params:
    if param.startsWith("@"):
      bookName = param[1..^1]
      break
  files.createNote(cmd, configuration, bookName)
  quit()

dispatchMulti(
  [catCmd,    cmdName = "cat",    positional = "query"],
  [configCmd, cmdName = "config"],
  [editCmd,   cmdName = "edit",   positional = "query"],
  [grepCmd,   cmdName = "grep",   positional = "searchTerm"],
  [lsCmd,     cmdName = "ls"],
  [mvCmd,     cmdName = "mv",     positional = "query"],
  [recentCmd, cmdName = "recent", short = {"limit": 'l'}],
  [rmCmd,     cmdName = "rm",     positional = "query"],
  [shareCmd,  cmdName = "share",  positional = "query"],
  [starCmd,   cmdName = "star",   positional = "query"],
  [tagsCmd,   cmdName = "tags",   positional = "tag"],
  [todoCmd,   cmdName = "todo",   short = {"add": 'a'}],
  [tmplCmd,   cmdName = "tmpl"]
)
