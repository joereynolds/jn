import std/[algorithm, parsecfg, sequtils, tables, terminal, times, strutils]
import ../[console, grep]
import ./todo.nim

type Agendas = OrderedTable[string, seq[Match]]

proc getAgenda*(config: Config, todos: seq[Match]): Agendas =
  var agendas: Agendas = initOrderedTable[string, seq[Match]]()

  for todo in todos:

    if "!" in todo.lineContent:
      var dueDate = getDueDate(todo.lineContent)[0]

      if dueDate != "":

        dueDate = dueDate[1..^1] # Trim the '!'
        agendas
          .mgetOrPut(dueDate, @[])
          .add(todo)
  
  var sortedAgendas = toSeq(agendas.pairs)
  sortedAgendas.sort(proc (a, b: (string, seq[Match])): int = cmp(a[0], b[0]))

  return sortedAgendas.toOrderedTable()

proc printAgenda*(agendas: Agendas) =
  for date, todos in agendas:
    let dt = parse(date, "YYYY-MM-dd")
    echo dt.format("dddd dd MMMM yyyy")
    for todo in todos:
      stdout.write("  " )
      dim(cleanTodoItem(todo))
      echo ""
