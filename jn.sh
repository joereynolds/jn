# Use shell for now, if it gets unwieldy, switch

# Move to config dir
notes_location=~/Documents/work
notes_prefix=$(date +%Y-%m-%d)
notes_suffix=".md"

get_editor() {
    echo $EDITOR
}

list_books() {
    echo 'Books:'
    ls -1 --color=never $notes_location
}

create_note() {
    nice_name=$(echo "$1" | tr ' ' '-')
    file_path=$notes_location/$notes_prefix-$nice_name$notes_suffix

    echo "$1" > $file_path
    _post_creation_notice "$file_path"
}

create_note_with_title() {
    nice_name=$(echo $2)
    file_path=$notes_location/$notes_prefix-$nice_name$notes_suffix
    echo $1 > $file_path
    _post_creation_notice "$file_path"
}

_post_creation_notice() {
    echo "Created $1"
}

fuzzy_provider() {
    fzy
}

jn__config() {
    $(get_editor) $XDG_CONFIG_HOME/jn/config.sh
}


jn() {
    if [ "$1" = "config" ]; then
        jn__config
    elif [ $# -eq 0 ]
    then
        list_books
    elif [ $# -eq 1 ]
    then
        create_note "$1"
    elif [ $# -eq 2 ]
    then
        echo 'here'
        create_note_with_title "$1" "$2"
    fi

}

jn "$@"
