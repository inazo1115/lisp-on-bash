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

function char_get() {
    echo $1 | cut -c $2
}

function word_head() {
    echo $1 | awk '{print $1}'
}

function word_tail() {
    echo $1 | sed 's/\[^\]/ /g'
}

# parse and eval
function parse() {

    expr=$1
    if [ -n "$expr" ]
    then
        echo ''
    fi

    head=$(char_get $expr 1)

    case $head in
        [a-zA-Z]* )
            if [ $(is_defined_func $expr) -o $(is_system_func $expr) ]
            then
                # func
                echo $expr
            else
                # str
                echo $expr
            fi
            ;;
        '$' )
            eval echo $expr
            ;;
        '(' )
            parse_list $expr
            ;;
        * )
            echo $expr
            ;;
        esac
}

function parse_list() {
    expr=$1
}

# user interface
function repl() {
    echo ''
}

# main

#repl
parse 'add 1 1'


