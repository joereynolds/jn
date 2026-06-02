import std/[options, parsecfg, re, sequtils, strformat, strutils, tables, times]
import ../[config, console, grep, files, todo]
import ../fuzzy/fuzzy

const name = "todo"

proc markTodo(config: Config, state: TaskState) =
  let todos = getTodos(config, TaskState.Todo)

  var displayChoices: seq[string] = @[]
  var matchLookup = initTable[string, Match]()

  for i, match in todos:
    let key = $i & " " & match.lineContent
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
    # i.e. (completed 2026-03-03)
    matchedContent.add(fmt" ({toTodoTask(state)}: {today})")

    writeToLine(
      matchedFile,
      matchedLineNumber,
      matchedContent.replace("[ ]", fmt"[{toSyntax(state)}]")
    )

    let pattern = re"(\d+) - \[ \]"
    let replaced = choice.replace(pattern, "").strip()

    console.success(fmt"Marked '{replaced}' as complete ({matchedFile}).")
  
proc addTodo(config: Config, todo: string) =
  let task = "- [ ] " & todo & "\p"
  let todoFile: string = getNotesPath(config) & "todo.md"

  let handle = open(
    todoFile,
    fmAppend
  )

  defer: handle.close()
  write(handle, task)
  success("Wrote '" & todo & "' to " & todoFile)

proc process*(config: Config, task: string, filter: Option[TaskState]) =

  if task != "":
    addTodo(config, task)
    return

  if filter.isSome:
    listTodos(config, filter.get)
    return

  markTodo(config, TaskState.Done)
