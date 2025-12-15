import std/os
import std/tables
import std/terminal


type DirectoryListing = Table[string, int]


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
