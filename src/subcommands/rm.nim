import std/os
import std/strutils
import std/tempfiles
import ../fuzzy
import ../console

proc process*() = 
    var choice = makeSelection()

    choice.stripLineEnd()

    if choice == "":
        quit()

    let content = readFile(choice)
    removeFile(choice)

    let (tempFile, path) = createTempFile("jn-", "")
    tempfile.write(content)

    let message = "Deleted " & choice & ". Backup is at " & path
    success(message)

    close tempFile
