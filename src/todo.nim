import std/parsecfg
import ./[grep]

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
  TaskDate* {.pure.} = enum
    Due = "!"
    Created = "+"
    Cancelled = "-"

proc toSyntax*(state: TaskState): TaskStateSyntax =
  case state:
  of Cancelled: TaskStateSyntax.Cancelled
  of Done: TaskStateSyntax.Done
  of Wip: TaskStateSyntax.Wip
  of Todo: TaskStateSyntax.Todo

proc toTodoTask*(state: TaskState): string =
  ## Render the state to a friendly string
  ## for the user
  case state:
  of Cancelled: "cancelled"
  of Done: "completed"
  of Wip: "in-progress"
  of Todo: "todo"

proc getTodos*(config: Config, state: TaskState): seq[Match] =
  let pattern = "^- \\[" & $toSyntax(state) & "\\] "
  getMatches(pattern, config)

proc listTodos*(config: Config, state: TaskState) =
  for todo in getTodos(config, state):
    echo todo.lineContent
