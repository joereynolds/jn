# JN

## What is it?

A command line notetaker with a filebased approach.

"books" are directories, "notes" are files, simple!


### Getting started

Run `jn` and it will create a config file for you under `XDG_CONFIG_HOME/jn/`.
This will most likely be `~/.config/jn/`

Change `notes_location` to point to where you store your notes, and that's it.


### Config

The config file lives inside `$XDG_CONFIG_HOME/jn/config.ini`.
Usually this is `~/.config/jn/`.

You can quickly edit the config file with

```
jn conf
``` 

(`jn config` also works)

A complete configuration is below:

```
notes_location="~/my-special-place" # default is XDG_DOCUMENTS_DIR
grep_command="egrep" # default is "rg"
find_command="find"  # default is "fd"
fuzzy_command="fzy"  # default is "fzf"
note_prefix=$(date)  # What a note's prefix should be when saved
note_suffix=".md"    # What a note's suffix should be when saved
```

## Commands

### Listing books and notes

#### List all books

```
jn
```

### List all notes for a book

```
jn @<your-book>
```

### Display your notes

```
jn cat
```

This will open a fuzzy finder for your notes, select the one you want and it
will be output


### Edit your notes

```
jn edit
```

This will open a fuzzy finder for your notes, select the one you want and it
will be opened in `$EDITOR`.

### Search your notes

```
jn grep <search-term>
```

This will open up a fuzzy finder of all notes with `search-term` present.
Select one and it will open up in `$EDITOR`.


### Adding books and notes


#### Writing a note

The complete syntax for writing a note is as follows:

```
jn <your note> <your title> @<your book>
```

The first argument is mandatory, the other two are optional.

Writing a note is as simple as:

```
jn "my note goes here"
```

This will write it out to your configured place (`XDG_DOCUMENTS_DIR` by
default).

By default, it will save the note with a date prefix, the first N words (how
many?) of the note and a markdown suffix.

So `jn "my note goes here"` is saved as "2025-12-05-my-note-goes-here.md".

The date and markdown extension are config options and can be changed if
desired.

See `note_prefix` and `note_suffix` in the config above.

Once a note is created, its location is echoed to the terminal:

```
> jn "Do the thing"
> Created ~/Documents/notes/2025-12-05-do-the-thing.md
```

#### Adding a title

You can of course add a title to your note if you don't want it inferred.

Doing

```
jn "My note goes here" "instructions"
> Created ~/Documents/notes/2025-12-05-instructions.md
```

#### Creating a book

A book is optional. Conceptually it's where you store related notes.
You might have a "vim" book containing tips about vim.
A "docker" book containing tips about Docker, you get the idea.

If you don't use books, it all just goes into the root directory defined in
your config.

Books are created automatically when you make notes.
It is the last argument in the chain and begins with a "@"

The following are valid:

```
jn ":q! quits vim" "how-to-quit-vim" @vim

Saved in XDG_DOCUMENTS_DIR/vim/2025-12-07-how-to-quit-vim.md
```

```
jn ":q! quits vim" @vim

Saved in XDG_DOCUMENTS_DIR/vim/2025-12-07-q-quits-vim.md
```

#### One note in multiple books

Let's say you have a "programming" book and also a "python" book.
You want one note to appear in both places, but how?

In order to do so, just specify both books 

i.e.

```
jn "a = 5 to assign in python" @python @programming
```

The above will create the note in "python" and create a symlink to it in
"programming".

The first link is the hard link, the rest are symlinks.
