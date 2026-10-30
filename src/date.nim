import std/[strutils, times]

## Gets the date from a given date following a human-like spec
## date is a string like "today"
## fromDate is when you want to act from. In 99% cases this would just be now()
## but it gives us more testability to inject it in
proc getRelativeDate*(date: string, fromDate: DateTime = now()): string =
  var modifier = 0
  case date.strip():
    of "yesterday":
      modifier = -1
    of "today":
      modifier = 0
    of "tomorrow":
      modifier = 1
    of "eom":
      let lastDay = getDaysInMonth(fromDate.month, fromDate.year)
      return dateTime(fromDate.year, fromDate.month, lastDay, 23, 59, 59).format("YYYY-MM-dd")

  let today = fromDate + modifier.days
  return today.format("YYYY-MM-dd")
