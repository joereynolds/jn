import std/[osproc, paths, re, strutils]

let pattern = re"{%\s*(.+?)\s*%}"

proc process*(templateContent: string, note: Path): string {.raises: [RegexError, OSError, IOError] .} =
  var content = templateContent

  for match in content.findAll(pattern):
    let command = match.replace(re"{%\s*|\s*%}", "")
    let output = execProcess(command).strip()
    content = content.replace(match, output)

  return content

