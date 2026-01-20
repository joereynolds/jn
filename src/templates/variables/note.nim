import std/[paths]

const keyword = "note"

proc process*(note: Path): string =
  return $lastPathPart(note)

