import std/[strutils, times]

proc getRelativeDate*(date: string): string =
  # TODO
  #
  # Add support for next/last as well as N 
  # i.e.
  # next year (1 * 365) days
  # last year (-1 * 365) days
  # 5 weeks ago (5 * -7) days
  # 5 weeks (5 * 7) days
  # next week (1 * 7) days
  # last week (1 * -7) days
  #
  # Months will be harder because 28/29/30/31 day months etc...
  var modifier = 0
  case date.strip():
    of "yesterday":
      modifier = -1
    of "today":
      modifier = 0
    of "tomorrow":
      modifier = 1

  let today = now() + modifier.days

  return today.format("YYYY-MM-dd")



  

