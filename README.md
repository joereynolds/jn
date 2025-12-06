# JN

## What is it?

A copy of DNote but filebased and imo better.
The idea is to be frictionless and match the user's intentions as much as possible.

It should:

- treat directories as books
- treat files as notes
- Work with any existing directories i.e. no need to create books, just point it at a dir if you want
- Save config in `XDG_CONFIG_HOME`
- Save books/notes in first in place specified by config, if not present, then
  in `XDG_DOCUMENTS_DIR` and if not present, just the cwd?
- Incorporate fuzzy search if we have one available fzy/fzf etc...
- Should be a config option for default edit style. Inline (on the terminal) or in your $EDITOR. Should also be able to override this with a flag

### Config

The config file is a shell script called `config.sh` that live inside `$XDG_CONFIG_HOME/jn/`.
Usually this is `~/.config/jn/`.

A complete configugration is below:

```
notes_location="~/my-special-place" # default is XDG_DOCUMENTS_DIR
grep_command="egrep" # default is "rg"
find_command="find"  # default is "fd"
fuzzy_command="fzy"  # default is "fzf"
note_prefix=$(date)  # What a note's prefix should be when saved
note_suffix=".md"    # What a note's suffix should be when saved
```

### Questions

- How should we go about tagging a note? Should we bother at all?
    - For example if a note is both C and PYthon related and you have those two dirs, where would they want to put it? 


Command examples

### Listing books and notes

#### List all books

```
jn
```

Should use `tree` to display the list

### List all notes

```

```

### List all book notes

```
jn <book> ls
```

#### Fuzzy finding

Pressing `<tab>` after any command will open up a fuzzy finder if one is available.
If one is not available, it will fall back to default bash tab completion

##### Fuzzy find all notes

```
jn <tab>
```

Pressing enter will `cat` the selected file out to stdout (I think? Maybe open in $EDITOR but that feels clunky).

##### Fuzzy find all books

```
jn book <tab>
```

Pressing enter will open up a new fuzzy finder for all notes in that book.
Pressing enter on the note will cat it to the terminal

### Searching books and notes


### Adding books and notes

#### Creating a book

A book is optional. Conceptually it's where you store related notes.
You might have a "vim" book containing tips about vim.
A "docker" book containing tips about Docker, you get the idea.

Books are optional, if you don't use books, it all just goes into the root directory

#### Writing a note

Writing a note is as simple as 

```
jn "my note goes here"
```
This will write it out to your configured place (`XDG_DOCUMENTS_DIR` by default)

By default, it will save the note with a date prefix, the first N words (how many?) of the note and a markdown suffix.

So `jn "my note goes here"` is saved as "2025-12-05-my-note-goes-here.md".

The prefix and suffixes are config options and can be changed if desired.

See config, to save you a click, the options are `note_prefix` and `note_suffix`.

Once a note is created, its location is echoed to the terminal

```
> jn "Do the thing"
> Created ~/Documents/notes/2025-12-05-do-the-thing.md
```

#### Adding a title

You can of course add a title to your note if you don't want it inferred.

Doing

```
jn "My note goes here" "instructions"
```

Saves as 2025-12-05-instructions.md
