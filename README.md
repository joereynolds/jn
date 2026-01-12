# JN

## What is it?

A command line notetaker with a filebased approach.

"books" are directories, "notes" are files, simple!

## Goals

- Be more convenient than the shell for finding and editing notes
- Be frictionless
- Be unixy

### Requirements

- ripgrep
- fzf or fzy

### Getting started

Run `jn` and it will create a config file for you under `XDG_CONFIG_HOME/jn/`.
This will most likely be `~/.config/jn/`

Change `notes_location` to point to where you store your notes.

From there you can list all your notes with `jn` or create some with `jn "my
note title"`.

That's it!

I recommend reading below to learn about everything you can do.

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
note_prefix="YYYY-MM-dd"            # What a note's prefix should be when saved
note_suffix=".md"                   # What a note's suffix should be when saved

fuzzy_provider="fzy"                # default is "fzf"
```

## Commands

### List all books

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

`jn e` also works. Most things have shorthand, see `jn -h` for the full list.

### Search your notes

```
jn grep <search-term>
```

This will open up a fuzzy finder of all notes with `search-term` present.
Select one and it will open up in `$EDITOR`.


### Writing a note

The complete syntax for writing a note is as follows:

```
jn <your note title> @<your book>
```

The first argument is mandatory, the rest is optional.

Writing a note is as simple as:

```
jn "my note goes here"
```

This will write it out to your configured place (`XDG_DOCUMENTS_DIR` by
default).

By default, it will save the note with a date prefix, your specified title, and
a markdown extension.

i.e.

```
jn "writing with vim"
```

Becomes

```
2025-12-05-writing-with-vim.md
```

The date and markdown extension are configurable options and can be changed if
desired.

See `note_prefix` and `note_suffix` in the config above.

Once a note is created, its location is echoed to the terminal:

```
> jn "Do the thing"
> Created ~/Documents/notes/2025-12-05-do-the-thing.md
```

### Creating a book


A book is optional. Conceptually it's where you store related notes. You might
have a "vim" book containing tips about vim. A "docker" book containing tips
about Docker, you get the idea.

If you don't use books, it all just goes into the root directory defined in
your config.

Books are created automatically when you make notes.
It is the last argument in the chain and begins with a "@"

The following are valid:

```
jn "quitting-vim" @vim

Saved in XDG_DOCUMENTS_DIR/vim/2025-12-07-quitting-vim.md
```

### One note in multiple books

Let's say you have a "programming" book and also a "python" book.
You want one note to appear in both places, but how?

In order to do so, just specify both books 

i.e.

```
jn "python basics" @python @programming
```

The above will create the note in "python" and create a symlink to it in
"programming".

The first link is the hard link, the rest are symlinks.

## Advanced Features

### Templates (unimplemented)

You can tell `jn` to infer a template from a note's title.

For example, let's say after every time you go to the gym, you want to note
down your measurements. It would be tedious to write it all out, or manually
copy and tweak a few values from an old one.

Instead, create a template, store it in templates dir (TODO where is this) and
add this into your config:

```
example config here
```

Now everytime you create a title with "gym" in it, it will use that template.
You can pass the `--no-template` flag if you don't want this behaviour for a
particular note

i.e.

```
jn --no-template "gym measurements september 2026"
```

### Categories (unimplemented)

Similar to templates, we have categories.

A category is just a way of automatically moving our note into its correct
place depending on the note title.

For example, you could make all of your gym notes automatically go into "@gym"
book, by doing the following:

```
example here
```

## Roadmap

- [x] - cat subcommand
- [x] - config subcommand
- [x] - edit subcommand
- [x] - grep subcommand
- [x] - Ability to star notes
- [ ] - Template support
- [ ] - Automatic categorisation
- [ ] - Shell completion

## Developers

To compile and run `jn`:

```
nimble build && jn
```

To run tests:

```
nimble test
```
