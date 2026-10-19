import std/[paths, times]

const keyword = "today"

proc process*(note: Path): string =
  let yesterday = now() + 1.days
  return yesterday.format("YYYY-MM-dd")
