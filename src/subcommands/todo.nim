import std/[parsecfg, re, strformat, strutils, tables, times]
import ../[config, console, fuzzy, grep, files, todo]

const aliases* = @["t", "todo", "task"]


proc completeTodo(config: Config) = 
  let todos = getTodos(config)

  var displayChoices: seq[string] = @[]
  var matchLookup = initTable[string, Match]()

  for i, match in todos:
    let key = $i & " " & match.lineContent
    displayChoices.add(key)
    matchLookup[key] = match

  var choice = selectFromChoice(displayChoices, config)

  choice.stripLineEnd()

  if choice == "":
    quit()

  let matchedFile = matchLookup[choice].file
  var matchedContent: string = matchLookup[choice].lineContent
  let matchedLineNumber = matchLookup[choice].lineNumber
  let today = now().format("YYYY-MM-dd")

  matchedContent.add(" " & today)

  writeToLine(
    matchedFile,
    matchedLineNumber,
    matchedContent.replace("[ ]", "[x]")
  )

  let pattern = re"(\d+) - \[ \]"
  let replaced = choice.replace(pattern, "").strip()

  console.success(
    &"Marked '{replaced}' as complete ({matchedFile})."
  )

proc addTodo(config: Config, todo: string) =
  let task = "- [ ] " & todo & "\p"
  let todoFile: string = getNotesPath(config) & "todo.md"

  let handle = open(
    todoFile,
    fmAppend
  )

  write(handle, task)
  success("Wrote '" & todo & "' to " & todoFile)

proc process*(config: Config, params: seq[string]) =

  # TODO - this is incredibly shaky. Move to cligen to make this cleaner
  if "--add" in params or "-a" in params:
    addTodo(config, params[^1])
    return

  completeTodo(config)
