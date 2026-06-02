import std/[options, os, strutils, tables]
import config
import console
import files
from ./todo as todoModule import TaskState

import cligen

import subcommands/[
  book, cat, config as sconfig, edit,
  grep, help, ls, mv, rm,
  share, star, tags, todo, tmpl,
  macros
]

clCfg.version = "1.2.0"
clCfg.noHelpHelp = true

let origRender = clCfg.render
let configuration = getConfig(getConfigLocation())
let params = commandLineParams()
let subcommands = getSubcommandNames()

createNecessaryDirectories(configuration)

const aliasMap = {
  "c": "cat",
  "conf": "config",
  "e": "edit",
  "/": "grep",
  "rg": "grep",
  "h": "help",
  "t": "todo",
  "temp": "template",
  "tm": "template",
}.toTable()

proc mergeParams(cmdNames: seq[string], cmdLine = commandLineParams()): seq[string] =
  result = cmdLine
  if result.len > 0 and result[0] in aliasMap:
    result[0] = aliasMap[result[0]]

proc catProxy(query: seq[string] = @[]) = cat.process(configuration, query.join(" "))
proc configProxy() = sconfig.process(configuration)
proc editProxy(query: seq[string] = @[]) = edit.process(configuration, query.join(" "))
proc grepProxy(query: seq[string] = @[]) = grep.process(configuration, query.join(" "))

proc lsProxy(
  recent: Option[int] = none(int),
  after: Option[string] = none(string),
  before: Option[string] = none(string),
  noPrintDate: Option[bool] = none(bool),
) = ls.process(configuration, recent, after, before, noPrintDate)

proc mvProxy(query: seq[string] = @[], plain: bool = false) = mv.process(configuration, query.join(" "), plain)
proc rmProxy(query: seq[string] = @[]) = rm.process(configuration, query.join(" "))
proc shareProxy(query: seq[string] = @[]) = share.process(configuration, query.join(" "))
proc starProxy() = star.process(configuration)
proc templateProxy() = tmpl.process(configuration)
proc tagsProxy(query: seq[string] = @[]) = tags.process(configuration, query.join(" "))

proc todoProxy(
  add: seq[string] = @[],
  filter: Option[TaskState] = none(TaskState)
) = todo.process(
  configuration,
  add.join(" "),
  filter
)

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

# Cligen's help is very ugly, use our own
if params[0] in @["h", "help", "-h", "--help"]:
  help.process(configuration)
  quit()

if params[0] in @["--version", "-v"]:
  echo clCfg.version
  quit()

# Don't show --version in subcommand help
clCfg.version = ""

# Everything else...
dispatchMulti(
  [catProxy,      cmdName = "cat",  positional = "query",],
  [configProxy,   cmdName = "config",                    ],
  [editProxy,     cmdName = "edit", positional = "query",],
  [grepProxy,     cmdName = "grep", positional = "query",],
  [lsProxy,       cmdName = "ls",                        ],
  [
    mvProxy,
    cmdName = "mv",
    positional = "query",
    help = {"plain": "Prevent implicitly adding prefixes and suffixes to your filename"}
  ],
  [rmProxy,       cmdName = "rm",    positional = "query"],
  [shareProxy,    cmdName = "share", positional = "query"],
  [starProxy,     cmdName = "star",                     ],
  [templateProxy, cmdName = "template",                 ],
  [tagsProxy,     cmdName = "tags",  positional = "query"],
  [
    todoProxy,
    cmdName = "todo",
    help = {"add": "Add a task"}
  ],
)

try:
  let validationResults = config.validate(configuration)
  for item in validationResults: echo item
except Exception as e:
  info(e.msg)
