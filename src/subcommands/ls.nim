import std/parsecfg
import ../[config, files]

const name = "ls"

proc process*(config: Config) =
  let notes = getFilesforDir(getNotesPath(config))

  for note in notes:
    echo note.name
