import std/[algorithm, parsecfg, sequtils, tables, times]
import ../[console, grep]
import ./todo.nim

type Agendas = OrderedTable[string, seq[Match]]

const agendaDateFormat = "dddd dd MMMM yyyy"

proc getAgenda*(config: Config, todos: seq[Match]): Agendas =
  var agendas: Agendas = initOrderedTable[string, seq[Match]]()

  for todo in todos:

    let dueDate = getDueDate(todo.lineContent)

    for date in dueDate:
      let cleanDueDate = date[1..^1] # Trim the '!'

      if cleanDueDate < now().format("YYYY-MM-dd"):
        continue

      agendas
        .mgetOrPut(cleanDueDate, @[])
        .add(todo)
  
  var sortedAgendas = toSeq(agendas.pairs)
  sortedAgendas.sort(proc (a, b: (string, seq[Match])): int = cmp(a[0], b[0]))

  return sortedAgendas.toOrderedTable()

proc printAgenda*(agendas: Agendas) =
  for date, todos in agendas:
    let dt = parse(date, "YYYY-MM-dd")
    echo dt.format(agendaDateFormat)
    for todo in todos:
      stdout.write("  " )
      dim(cleanTodoItem(todo))
      echo ""
