#!/bin/bash -e
# Title: appimagedl
# Description: Easily download AppImages and keep them up to date.
# Description: Uses https://appimage.github.io/feed.json to get information about available AppImages.
# Author: simonizor (simoniz0r)
# License: MIT
# Dependencies: appimageupdatetool, jq, wget

_appimagedlzsh() {
    if [ -f ~/.appimagedl.conf ]; then
        . ~/.appimagedl.conf
    elif [ -f ~/.config/appimagedl/appimagedl.conf ]; then
        . ~/.config/appimagedl/appimagedl.conf
    fi

    local curcontext="$curcontext" state line
    typeset -A opt_args
 
    _arguments \
        '1: :->args'\
        '2: :->input'
 
    case $state in
    args)
        _arguments '1:arguments:(list info search download get remove update revert freeze config man help --verbose --debug)'
        ;;
    *)
        case $words[2] in
        download|dl|info|i|get)
            compadd "$@" $(dir -C -w 1 "$CONFIG_DIR"/list | sed 's%.json%%g')
            ;;
        remove|rm|update|up|revert|rev|freeze|fr)
            compadd "$@" $(dir -C -w 1 "$CONFIG_DIR"/downloaded)
            ;;
        esac
    esac
}

_appimagedlbash() {
    if [ -f ~/.appimagedl.conf ]; then
        . ~/.appimagedl.conf
    elif [ -f ~/.config/appimagedl/appimagedl.conf ]; then
        . ~/.config/appimagedl/appimagedl.conf
    fi
    local cur prev opts base
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    #
    #  The basic options we'll complete.
    #
    opts="list info download get remove update revert freeze config man help --verbose --debug"


    #
    #  Complete the arguments to some of the basic commands.
    #
    case "${prev}" in
        download|dl|info|i|get)
            local appimagelist="$(dir -C -w 1 "$CONFIG_DIR"/list | sed 's%.json%%g')"
            COMPREPLY=( $(compgen -W "${appimagelist}" -- ${cur}) )
            return 0
            ;;
        remove|rm|update|up|revert|rev|freeze|fr)
            local appimagedled="$(dir -C -w 1 "$CONFIG_DIR"/downloaded)"
            COMPREPLY=( $(compgen -W "${appimagedled}" -- ${cur}) )
            return 0
            ;;
        *)
        ;;
    esac

   COMPREPLY=($(compgen -W "${opts}" -- ${cur}))  
   return 0
}
