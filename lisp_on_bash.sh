#!/bin/bash

# predefined functions
function add() {
    echo $@ | sed 's/ /+/g' | bc
}

function sub() {
    echo $@ | sed 's/ /-/g' | bc
}

function mul() {
    echo $@ | sed 's/ /*/g' | bc
}

function div() {
    echo $@ | sed 's/ /\//g' | bc
}

# utility functions
function is_defined_func() {
    func_name=$1
    type $func_name > /dev/null 2>&1
    echo $?
}

function is_system_func() {
    func_name=$1
    which $func_name > /dev/null 2>&1
    echo $?
}

function len() {
    echo -n $1 | wc -c
}

function char_head() {
    echo $1 | cut -c1
}

function char_tail() {
    echo $1 | cut -c2-
}

function word_head() {
    echo $1 | cut -d' ' -f1
}

function word_tail() {
    n_col=$(echo $1 | awk '{print NF}')

    if [ $n_col -lt 2 ]
    then
        echo ''
        return
    fi

    echo $1 | cut -d' ' -f2-
}

function abort() {
    echo "$@" 1>&2
    exit 1
}

# read and eval
function parse_list() {
    expr=$(echo $1 | sed 's/(//' | sed 's/)/ )/g')

    list=''
    rest=''
    while true
    do
        head=$(char_head "${expr}")
        if [ "${head}" = ')' ]
        then
            rest=$(char_tail "${expr}")
            break
        fi

        res=$(parse "${expr}")
        list="${list} $(word_head ${res})"
        expr=$(word_tail "${res}")
    done

    echo "$(eval $list) ${rest}"
}

function parse() {
    expr=$1

    if [ -z "${expr}" ]
    then
        echo ''
        return
    fi

    case $(char_head "${expr}") in
        [_a-zA-Z]* )
            if [ $(is_defined_func $expr) -o $(is_system_func $expr) ]
            then
                # func
                echo "${expr}"
            else
                # str
                echo "${expr}"
            fi
            ;;
        '(' )
            parse_list "${expr}"
            ;;
        ')' )
            abort '*** Will not reach here'
            ;;
        * )
            # number
            echo "${expr}"
            ;;
    esac
}

# user interface
function repl() {
    while true
    do
        echo -n 'lisp-on-bash> '
        read cmd
        echo $(parse "${cmd}")
    done
}
