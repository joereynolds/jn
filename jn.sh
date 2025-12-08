# Use shell for now, if it gets unwieldy, switch

# Move to config dir
notes_location=~/Documents/work
notes_prefix=$(date +%Y-%m-%d)
notes_suffix=".md"

find_provider_fd_list_notes() {
    fd . $(get_notes_location) --type file
}

get_notes_location() {
    echo $notes_location
}

get_editor() {
    echo $EDITOR
}

get_config_dir() {
    echo $XDG_CONFIG_HOME
}

list_notes() {
    find_provider_fd_list_notes
}

list_books() {
    echo 'Books:'
    ls -1 --color=never $notes_location
}

create_note() {
    if [ $# -eq 1 ]; then
        nice_name=$(echo "$1" | tr ' ' '-')
    elif [ $# -eq 2 ]
    then
        nice_name=$(echo $2)
    fi

    file_path=$notes_location/$notes_prefix-$nice_name$notes_suffix

    echo "$1" > $file_path
    _post_creation_notice "$file_path"
}

_post_creation_notice() {
    echo "Created $1"
}

fuzzy_provider() {
    fzy
}

jn__config() {
    $(get_editor) $(get_config_dir)/jn/config.sh
}

jn() {
    if [ "$1" = "config" ]; then
        jn__config
    elif [ "$1" = "ls" ]; then
        list_notes
    elif [ $# -eq 0 ]
    then
        list_books
    elif [ $# -gt 0 ]
    then
        create_note "$@"
    fi
}

jn "$@"
