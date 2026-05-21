import std/[options, parsecfg, re, strformat, strutils, tables, terminal, times]
import ../[config, console, fuzzy, grep, files, todo]

const name = "todo"

proc completeTodo(config: Config) = 
  let todos = getTodos(config, TaskState.Todo)

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

proc markAs(state: TaskState) =
  echo state

proc promptForTaskState(): TaskState =
  echo "Mark task as:"

  echo "[1] - Done"
  echo "[2] - Cancelled"
  echo "[3] - Work in progress"
  echo "[4] - Todo"

  while true:
    let choice = getch()

    case choice:
    of '1': return TaskState.Done
    of '2': return TaskState.Cancelled
    of '3': return TaskState.Wip
    of '4': return TaskState.Todo
    else:
      quit()

proc listTodos(config: Config, state: TaskState) =
  for todo in getTodos(config, state):
    echo todo.lineContent

proc process*(config: Config, task: string, filter: Option[TaskState]) =
  echo promptForTaskState()
  #
  # if task != "":
  #   addTodo(config, task)
  #   return
  #
  # if filter.isSome:
  #   listTodos(config, filter.get)
  #   return
  #
  # completeTodo(config)
