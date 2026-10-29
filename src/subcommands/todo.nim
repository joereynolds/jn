import std/[
  os, options, parsecfg, re, 
  sequtils, strformat, strutils, 
  tables, terminal, times
]
import ../[config, console, grep, files, todo]
import ../fuzzy/fuzzy

const name = "todo"

proc markTodo(config: Config, state: TaskState) =
  let todos = getTodos(config, TaskState.Todo)

  if todos == @[]:
    info("You have 0 pending tasks. Create some with: jn todo --add 'your task here'")
    return

  var displayChoices: seq[string] = @[]
  var matchLookup = initTable[string, Match]()

  for i, match in todos:
    let displayContent = match.lineContent[5..^1]
    let key = $i & "." & displayContent
    displayChoices.add(key)
    matchLookup[key] = match

  var choice = selectFromChoice(displayChoices, config)

  choice.stripLineEnd()

  if choice == "": quit()

  let choices = choice.split("\0").filterIt(it != "")

  for choice in choices:
    let matchedFile = matchLookup[choice].file
    var matchedContent: string = matchLookup[choice].lineContent
    let matchedLineNumber = matchLookup[choice].lineNumber
    let today = now().format("YYYY-MM-dd")

    # add a mark of when we changed the task to that state
    # i.e. x2026-03-03
    matchedContent.add(fmt" {toTaskDateMarker(state)}{today}")

    writeToLine(
      matchedFile,
      matchedLineNumber,
      matchedContent.replace("[ ]", fmt"[{toSyntax(state)}]")
    )

    let pattern = re"(\d+) - \[ \]"
    let replaced = choice.replace(pattern, "").strip()

    console.success(fmt"Marked '{replaced}' as complete ({matchedFile}).")

proc getTodoFile(config: Config): string =
  getNotesPath(config) & "todo.md"
  
proc addTodo(config: Config, todo: string, due: Option[string]) =
  let today = now().format("YYYY-MM-dd")
  let creation = " " & $TaskDateMarker.Created & today

  var dueDate = ""
  if due.isSome:
    dueDate = $TaskDateMarker.Due & due.get

  let task = "- [ ] " & todo & creation & " " & dueDate & "\p"

  let todoFile = getTodoFile(config)
  let handle = open(todoFile, fmAppend)

  defer: handle.close()
  write(handle, task)
  success("Wrote '" & todo & "' to " & todoFile)

proc process*(
  config: Config,
  task: string,
  filter: Option[TaskState],
  edit: bool,
  due: Option[string]
) =

  let todoFile = getTodoFile(config)

  console.info(todoFile)

  if edit:
    discard os.execShellCmd(getEditor() & " " & todoFile)
    return

  if task != "":
    addTodo(config, task, due)
    return

  if not stdin.isatty():
    let stdinTask = stdin.readAll().strip()

    if stdinTask != "":
      addTodo(config, stdinTask, due)
    return

  if filter.isSome:
    listTodos(config, filter.get)
    return

  markTodo(config, TaskState.Done)
