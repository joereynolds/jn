import std/[paths, times]

const keyword = "today"

proc process*(note: Path): string =
  return now().format("YYYY-MM-dd")
