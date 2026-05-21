import std/[macros, os]

macro getSubcommandNames*(): seq[string] =
  ## Grabs all `const name = 'bla'` and brings them back
  result = newStmtList()
  var subcommandNames: seq[string] = @[]

  for kind, path in walkDir(currentSourcePath().parentDir()):
    let content = staticRead(path)
    let ast = parseStmt(content)

    for node in ast:
      if node.kind == nnkConstSection:
        for constant in node:
          
          if constant.kind == nnkConstDef and constant[0].eqIdent("name"):
            let valNode = constant[2]

            if valNode.kind == nnkStrLit:
              subcommandNames.add(valNode.strVal)

    result = newLit(subcommandNames)
