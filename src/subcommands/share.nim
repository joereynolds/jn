import std/[parsecfg, sequtils, sugar, strutils, httpclient]
import ../[config, console]
import ../fuzzy/fuzzy

const name = "share"

proc process*(config: Config, query: string) =
  var choice = selectFromDir(
    getNotesPath(config),
    config,
    query
  )

  choice.stripLineEnd()
  if choice == "": quit()

  let choices = choice.split("\0")
                      .map(c => c.strip())
                      .filterIt(it != "")

  let url = "https://paste.rs"

  var content = ""
  let client = newHttpClient()

  let count = choices.len

  for choice in choices:
    content &= readFile(choice)
  
  try:
    let response = client.postContent(url, body=content)
    success("Shared " & $count & (if count == 1: " note to " else: " notes to ") & response & ".md")
  finally:
    client.close()
