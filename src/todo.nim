import std/parsecfg
import ./[grep]

type 
  TaskState* = enum
    Done = "done"
    Wip = "wip"
    Cancelled = "cancelled"
    Todo = "todo"

type
  TaskStateSyntax = enum
    Done = "x"
    Wip = "/"
    Cancelled = "-"
    Todo = " "

proc toSyntax(state: TaskState): TaskStateSyntax =
  case state:
  of Cancelled: TaskStateSyntax.Cancelled
  of Done: TaskStateSyntax.Done
  of Wip: TaskStateSyntax.Wip
  of Todo: TaskStateSyntax.Todo

proc getTodos*(config: Config, state: TaskState): seq[Match] =
  let pattern = "^- \\[" & $toSyntax(state) & "\\] "
  getMatches(pattern, config)
