import std/[osproc, paths, re, strutils]

let pattern = re"{%\s*(.+?)\s*%}"

proc process*(templateContent: string, note: Path): string {.raises: [RegexError, OSError, IOError] .} =
  result = templateContent

  var matches = result.findAll(pattern)
  
  while matches.len > 0:
    let match = matches[0]
    let command = match.replace(re"{%\s*|\s*%}", "").strip()
    let output = execProcess(command).strip()
    result = result.replace(match, output)
    matches = result.findAll(pattern)

