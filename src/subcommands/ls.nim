import std/parsecfg
import ../[config, files]


proc process*(config: Config) =
  let notes = getFilesforDir(getNotesPath(config))

  for note in notes:
    echo note.name
