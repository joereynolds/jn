# JN

<img width="535" height="470" alt="image" src="https://github.com/user-attachments/assets/f34e2dcc-bee9-4c29-8c8e-90ad4d59c6ba" />

A command line notetaker and basic task manager

### Features

- All your notes managed as files. No databases or sign-ups
- Create, remove, share and search your notes from the comfort of the terminal
- Small. Like, less than a megabyte

https://github.com/user-attachments/assets/2b73cacb-2d75-452e-9c08-1220bc6af82a

### Requirements

- fzf, fnf, or fzy (Other fuzzy finders will probably work but are untested)

`jn` will work without one but be limited.

### Installation

Download Linux and Mac builds of `jn` from the [releases page](https://github.com/joereynolds/jn/releases).

### Quick start

- `jn "my note title"` creates a note called `2026-01-01-my-note-title.md` and opens it in your `$EDITOR`.
- `jn` on its own will show all your "books" (directories)
- `jn todo` to complete and filter your tasks
- And so much more!

#### Command overview

Detailed info for each command is below this table.


| Command              | Description                        | Flags                                                         |
|----------------------|------------------------------------|---------------------------------------------------------------|
| `jn`                 | List all books                     |                                                               |
| `jn <title>`         | Create a note                      |                                                               |
| `jn <title> @<book>` | Create a note in a specific book   |                                                               |
| `jn @<book>`         | List notes in a book               |                                                               |
| `jn @starred`        | List bookmarked notes              |                                                               |
| `jn cat`             | Display a note                     |                                                               |
| `jn edit`            | Edit a note                        |                                                               |
| `jn ls`              | List all notes                     | `--recent [n]` Display the N most recently edited notes <br>`--before` Show notes before this date (yyyy-MM-dd format)<br> `--after` Show notes after this date (yyyy-MM-dd format)<br>`--no-print-date` Hides the date display     |
| `jn grep <term>`     | Search notes by content            |                                                               |
| `jn tag <tag>`       | Search notes by tag                |                                                               |
| `jn mv`              | Rename a note                      | `--plain` Whether to append dates and extension during rename |
| `jn rm`              | Delete a note                      |                                                               |
| `jn star`            | Bookmark a note                    |                                                               |
| `jn share`           | Upload a note and get a permalink  |                                                               |
| `jn todo`            | Show and complete incomplete tasks | `--add [task]` Create a task<br> `--filter` Filter on cancelled,completed,wip, and todo states |
| `jn template`        | Edit a template                    |                                                               |
| `jn config`          | Edit the config file               |                                                               |
| `jn help`            | Show help                          |                                                               |
| `jn <cmd> -h`        | Get help for an individual command |                                                               |



### Config

All of `jn`s config lives in a single config.ini file.

The config file lives inside `$XDG_CONFIG_HOME/jn/config.ini`.
Usually this is `~/.config/jn/config.ini`.

You can quickly edit the config file with

```
jn conf
``` 

(`jn config` also works)

Complete configuration:

```
; The location that jn stores and retrieves notes from
; By default this is XDG_DOCUMENTS_DIR/jn/
; e.g. ~/.config/jn/config.ini
;
; notes_location ="~/Documents/jn/"

; The location that jn retrieves templates from
; By default this is XDG_DATA_HOME/jn/
; e.g. ~/.local/share/jn
;
; templates_location ="~/.local/share/jn"

; The prefix of the note. I.e. what to prepend the title with.
; Meaning that if you create a note called "daily journal",
; it will be saved as 2026-01-01-daily-journal.md
;
; The prefix can be any of the format patterns specified in 
; https://nim-lang.org/docs/times.html

; The default if not supplied is "YYYY-MM-dd"
;
; notes_prefix="YYYY-MM-dd"

; The suffix for the note, this is just the extension.
; The default if not supplied is ".md" i.e. Markdown
;
; notes_suffix=".md"

; The fuzzy provider to use with jn. The default if not supplied is fzf.
; Valid values are "fzf" or "fzy" (others may work coincidentally)
;
; fuzzy_provider="fzy"

;
;[template.example-1]
;title_contains="gym,lift,gains"
;use_template="measurements.md"
;
;[template.example-2]
;title_contains="chocolate"
;use_template="recipe.md"
;
; [category.gym]
; title_contains="gym"
; move_to="health"
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

### Display a note

```
jn cat
```

This will open a fuzzy finder for your notes, select the one you want and it
will be output

### Edit a note

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

`jn / <search-term>` also works if you're used to Vim.

### Delete a note

```
jn rm
```

This will open a fuzzy finder for your notes. Select the note you want and it
will be deleted.

Once the file has been "deleted", a file containing the deleted file's content
is written to "/tmp/" (or the equivalent on Mac/Windows) so you can restore it
in the event of a mistake.

### Create a note

The complete syntax for writing a note is as follows:

```
jn <your note title> @<your book>
```

The first argument is mandatory, the rest is optional.

Writing a note is as simple as:

```
jn "my note goes here"
```

This will drop you into your `$EDITOR` for you to write content. It will then
write out to your configured place (`XDG_DOCUMENTS_DIR` by default).

By default, it will save the note with a date prefix, your specified title, and
a markdown extension.

i.e.

```
jn "writing with vim"
```

Will save as

```
2025-12-05-writing-with-vim.md
```

The date and markdown extension are configurable options and can be changed if
desired.

See `note_prefix` and `note_suffix` in the config above.

Once a note is created, its location is echoed to the terminal:

```
> jn "Do the thing"
> ...
> Created ~/Documents/notes/2025-12-05-do-the-thing.md
```

### Bookmark a note

```
jn star
```

This will open a fuzzy finder for your notes. Select the note you want and it
will be bookmarked.

When a file has been bookmarked, it will appear in the special `@starred` book.

To view your bookmarks, use the `@starred` book like any other:

```
jn @starred
```

Internally, bookmarks are managed with symlinks. The original note remains in
its current location and a symlink is created in the "starred" directory to
that note.

### Rename a note

```
jn mv
```

This will open a fuzzy finder for your notes. Select the note you want and it
will prompt you for the new name.

You only need to supply the title of the note, the prefix and extension are
provided for you.

i.e. If you rename a note from `2026-01-01-important.md` to `urgent` it will be
saved as `2026-01-01-urgent.md`.

You can also pass the `--plain` flag to `jn mv` and it will do no clever
prefix/extension magic and instead, just rename the file to what you want
whilst still preserving the directory it's in.

The complete command is:

```
jn mv --plain
```

### List your notes

```
jn ls
```

This is purely for convenience. You could definitely just do `ls
~/wherever-your-notes-live` but who has that kind of brainpower?

Doing `jn ls` will list all the notes in your configured location.

You can also filter by `--recent` to get your most recently edited notes.
Handy for when you forgot what you were working on.

```
jn ls --recent 6 # return the 6 most recently edited notes
```

### Share a note

```
jn share
```

Select a note and it will be uploaded to an online service which will give you
a permalink in return.

### Creating a book

A book is optional. Conceptually it's where you store related notes. You might
have a "vim" book containing tips about vim. A "docker" book containing tips
about Docker, you get the idea.

If you don't use books, it all just goes into the root directory defined in
your config.

Books are created automatically when you make notes.
It is the last argument in the chain and begins with a "@"

E.g.:

```
jn "quitting-vim" @vim

Saved in ~/Documents/notes/vim/2025-12-07-quitting-vim.md
```


## Other Features

### Todos

`jn todo` is able to manage tasks with markdown checkbox syntax.

When invoked, it will bring up a fuzzy finder containing all of your incomplete
tasks. When an item is selected, it will mark that item/task as completed along
with today's date next to the item.

For example:

```
> jn todo
user selects and confirms their todo item
> Marked 'drink protein shake' as complete (/home/joe/Documents/jn/notes/Home.md).
```

An incomplete task has the following formatting:

```
- [ ] This is an incomplete task seen in extended Markdown examples
```

A complete task has the following formatting:

```
- [x] This is a complete task seen in extended Markdown examples
```

You can add todos with the `--add` or `-a` flag.

```
jn todo --add "Do the dishes"
```

Will add a markdown task in your `notes_location` / todo.md

#### Filtering todos

If you want to see all your done tasks (or other states), you can do with the `--filter` flag.

There are 4 states that a task can be in demonstrated below:

```
- [ ] This task's state is "todo"
- [x] This task's state is "done"
- [/] This task's state is "wip"
- [-] This task's state is "cancelled"
```

This closely mirrors how many obsidian plugins treat markdown tasks, for consistency.

To filter, you do:

```
jn todo --filter <taskstate>
```
e.g.
```
jn todo --filter cancelled
```

Shorthand works too, here's the exact same command:

```
jn t -f ca
```

### Tags

As you'd expect, you can search for tags via `jn`. All tags are assumed to
begin with "#".

As an example, any of the below will search for the "#vim" tag.

```
jn tag vim
jn tag "#vim"
jn tags vim
jn tags "#vim
```

Once ran, this will open up a fuzzy finder containing all notes with those
tags.

As you can see, you don't need to specify the `#` prefix in your search. Just
the word will do.

### Templates

You can tell `jn` to use a template based on a note's title.

For example, let's say that after every time you go to the gym, you want to
note down your measurements. It would be tedious to write it all out, or
manually copy and tweak a few values from an old one.

Instead, create a template, and store it in `XDG_DATA_HOME/jn` (usually this
is`~/.local/share/jn`).

Once you've done that, add this into your config:

```
[template.my-template]
title_contains = "exercise,lift,bro,gains"
use_template = "gym-measurements.md"
```

Now everytime you create a title with "exercise" or any of the other words in
that list _somewhere_ in the title, it will populate the note with the content
of `XDG_DATA_HOME/jn/gym-measurements.md`.


#### Template variables

##### Predefined variables

You can use predefined template variables in your templates.

For example, a template consiting of

```
Today is {{ today }}
```

Would be rendered as:

```
Today is 2026-01-20
```

A complete overview of the template variables is below:


| Variable    | Action                                        |
| ------------| ----------------------------------------------|
| today       | Renders today's date in YYYY-MM-dd format     |
| note        | Renders the complete filename of the note     |


Note that template variables are very fresh, so there aren't many...

If you have any suggestions on useful ones, raise an issue.

##### Shell variables

Another more powerful (and dangerous/fun) type of template variable is the
shell variable.

This allows you to shell out and fill the template with results of the shell
command.

Shell template variables start with `{%` and end with `%}`. 

For example we can do:

```
The year is {% date +%Y %}.

Hello {% echo 'Joe' %} And hello {% echo 'Jim' %}. 
Here is a list of my files {% ls %}. 
I hope you like them {% echo 'Joe' %}. 

Written on {{ today }}.
```

The onus is on you to write the command correctly. It not working is undefined behaviour.


#### Editing a template

```
jn template
```

This will open a fuzzy finder of all your templates. Select the template and it
will open up in `$EDITOR`.

### Categories

Categories allow you to automatically move a note to a book based on the name
of the note.

For example, let's say you have a book called @recipes that stores all your...
recipes. You want to have any new note that contains the word "chocolate" or
"snack to immediately be moved to recipes.

You can do so with the following:

```
[category.my-category]
title_contains = "chocolate,snack"
move_to = "recipes"
```

Now, on save of your note, it gets saved into the @recipes book.

This saves you having to manually move files around or add the note to the
correct book in the first place


## Config file locations

Config - `XDG_CONFIG_HOME/jn/` (usually this is `~/.config/jn`)

Documents - `XDG_DOCUMENTS_DIR/jn/` (usually this is `~/Documents/`) (defaults to `~/Documents/`) can be overridden with `notes_location` config key

Templates - `XDG_DATA_HOME/jn/` (usually this is `~/.local/share/jn/`)

## Roadmap

- [x] - cat subcommand
- [x] - config subcommand
- [x] - edit subcommand
- [x] - grep subcommand
- [x] - rm subcommand
- [x] - Ability to star notes
- [x] - Template support
- [x] - Categories
- [ ] - Shell completion
- [ ] - Man page

## Developers

To compile and run `jn`:

```
nimble build && jn
```

To run tests:

```
nimble test
```
