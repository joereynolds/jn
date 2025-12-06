# Use shell for now, if it gets unwieldy, switch

# Move to config dir
notes_location=~/Documents/jn
notes_prefix=$(date +%Y-%m-%d)
notes_suffix=".md"


list_books() {
    echo 'Books:'
    ls --color=never $notes_location
}

create_note() {
    nice_name=$(echo $1 | tr ' ' '-')
    file_path=$notes_location/$notes_prefix-$nice_name$notes_suffix

    echo $1 > $file_path
}

create_note_with_title() {
    nice_name=$(echo $2)
    file_path=$notes_location/$notes_prefix-$nice_name$notes_suffix
    echo $1 > $file_path
}

fuzzy_provider() {
    fzy
}

jn() {

    if [ $# -eq 0 ]
    then
        list_books
    fi

    if [ $# -eq 1 ]
    then
        create_note
    fi

    if [ $# -eq 2 ]
    then
        create_note_with_title "$1" "$2"
    fi
}
