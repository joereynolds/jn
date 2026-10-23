import std/[paths]
import ../../date

proc process*(note: Path): string =
  getRelativeDate("yesterday")
