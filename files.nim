import std/os
import std/tables
import std/terminal
import std/times
import std/parsecfg
import std/strutils

import config


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

    let fullName = prefix & "-" & note.replace(" ", "-") & suffix

    return fullName

proc createNote*(noteName: string) =

    let name = getFullNoteName(noteName)

    let message = "Created " & name
    stdout.styledWriteLine(fgGreen, message)


proc getNotes*(notesDir: string): seq[string] =
    var notes = @[""]

    for note in walkDirRec(expandTilde(notesDir)):
        notes.add(note)
    return notes


proc getDirectories*(notesDir: string): DirectoryListing =
    var directories = initTable[string, int]()

    for kind, path in walkDir(expandTilde(notesDir)):

        let path_as_key = lastPathPart(path)
        if kind == pcDir and not isHidden(path):
            directories[path_as_key] = 0

            for other_kind, other_path in walkDir(path):
                if other_kind == pcFile:
                    directories[path_as_key] += 1

    return directories


proc printDirectories*(directories: DirectoryListing) =
    for directory, fileCount in directories:
        let noteCount = " (" & $fileCount & " notes" & ")"

        stdout.write(directory)
        stdout.styledWriteLine(fgYellow, noteCount)
