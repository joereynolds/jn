import std/[parsecfg, re]
import ./../grep

type 
  TaskState* = enum
    Done = "done"
    Wip = "wip"
    Cancelled = "cancelled"
    Todo = "todo"

## The state of the task itself
type
  TaskStateSyntax {.pure.} = enum
    Done = "x"
    Wip = "/"
    Cancelled = "-"
    Todo = " "

## The information about when a task was created/due etc... i.e. !2026-01-01
type 
  TaskDateMarker* {.pure.} = enum
    Due = "!"
    Created = "+"
    Cancelled = "-"
    Done = "x"

    # Have to specify these but they are unused
    Wip = ""
    Todo = ""

let creationDatePattern* = re"\+\d{4}-\d{2}-\d{2}"
let completionDatePattern* = re"x\d{4}-\d{2}-\d{2}"
let DueDatePattern* = re"!\d{4}-\d{2}-\d{2}"

## Removes all the metadata and markdown syntax from the todo
## Leaves just the task
proc cleanTodoItem*(todo: Match): string =
    todo.lineContent[6..^1] # Trim the '- [ ] '
      .replace(creationDatePattern, "")
      .replace(completionDatePattern, "")
      .replace(DueDatePattern, "")

proc toSyntax*(state: TaskState): TaskStateSyntax =
  case state:
  of Cancelled: TaskStateSyntax.Cancelled
  of Done: TaskStateSyntax.Done
  of Wip: TaskStateSyntax.Wip
  of Todo: TaskStateSyntax.Todo

proc toTaskDateMarker*(state: TaskState): TaskDateMarker =
  case state:
  of Cancelled: TaskDateMarker.Cancelled
  of Done: TaskDateMarker.Done
  of Wip: TaskDateMarker.Wip
  of Todo: TaskDateMarker.Todo

proc getDueDate*(todo: string): seq[string] =
  return findAll(todo, DueDatePattern)
  
proc getTodos*(config: Config, state: TaskState): seq[Match] =
  let pattern = "^- \\[" & $toSyntax(state) & "\\] "
  getMatches(pattern, config)

proc listTodos*(config: Config, state: TaskState) =
  for todo in getTodos(config, state):
    echo todo.lineContent
