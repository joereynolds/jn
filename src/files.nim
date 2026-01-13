import std/os
import std/tables
import std/times
import std/parsecfg
import std/strutils

import config
import console


type DirectoryListing = Table[string, int]

proc getFullNoteName(
    note: string,
    config: Config = config.configuration
): string =

    let dateFormat = config.getSectionValue(
        "",
        "notes_prefix"
    )

    let prefix = now().format(dateFormat)

    let suffix = config.getSectionValue(
        "",
        "notes_suffix"
    )

    let location = config.getNotesLocation()

    let fullName = expandTilde(location) & prefix & "-" & note.replace(" ", "-") & suffix

    return fullName

proc createNote*(noteName: string) =

    let name = getFullNoteName(noteName)
    let shouldGetTemplate = true  # TODO - Make sure to read flags for --no-template

    if shouldGetTemplate:
        let templates = getTemplates()

        for myTemplate in templates:
            if name.contains(myTemplate.titleContains):
                echo "insert template"

    discard os.execShellCmd(getEditor() & " " & name)
    let message = "Created " & name

    success(message)


proc getNotes*(notesDir: string): seq[string] =
    var notes = @[""]

    for note in walkDirRec(
        expandTilde(notesDir),
        yieldFilter = {pcFile, pcLinkToFile}
    ):
        notes.add(note)
    return notes


proc getDirectories*(notesDir: string): DirectoryListing =
    var directories = initTable[string, int]()

    directories["."] = 0

    # Get all directories
    for kind, path in walkDir(expandTilde(notesDir)):

        if kind == pcFile:
            directories["."] += 1

        let pathAsKey = lastPathPart(path)
        if kind == pcDir and not isHidden(path):
            directories[pathAsKey] = 0

            # and count all notes
            for file in walkDirRec(
                path,
                yieldFilter = {pcFile, pcLinkToFile}
            ):
                directories[pathAsKey] += 1

    return directories


proc printDirectories*(directories: DirectoryListing) =
    for directory, fileCount in directories:
        let noteCount = " (" & $fileCount & " notes" & ")"

        stdout.write(directory)
        info(noteCount)
