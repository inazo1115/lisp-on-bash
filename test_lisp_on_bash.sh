#!/bin/bash

source ./lisp_on_bash.sh

PASS=0
FAIL=0

function eq() {
    title=$1
    expected=$2
    actual=$3

    if [ "$expected" = "$actual" ]
    then
        PASS=$((PASS + 1))
    else
        echo "fail: ${title}    expected: ${expected}    actual: ${actual}"
        FAIL=$((FAIL + 1))
    fi
}

function report() {
    echo "--------------------------------"
    echo "pass: ${PASS}    fail: ${FAIL}"
}

# tests

eq 'add' 3 $(add 1 2)
eq 'sub' -1 $(sub 1 2)
eq 'mul' 2 $(mul 1 2)
eq 'div' 2 $(div 10 5)

eq 'is_defined_func pos' 0 $(is_defined_func add)
eq 'is_defined_func neg' 1 $(is_defined_func addadd)
eq 'is_system_func pos' 0 $(is_system_func echo)
eq 'is_system_func neg' 1 $(is_system_func echoecho)

eq 'char_head' f $(char_head foo)
eq 'char_tail' oo $(char_tail foo)

eq 'word_head' 'foo' "$(word_head 'foo bar baz')"
eq 'word_tail 0' 'bar baz' "$(word_tail 'foo bar baz')"
eq 'word_tail 1' '' "$(word_tail '')"
eq 'word_tail 2' '' "$(word_tail 'foo')"

eq 'parse_doller 0' '$' $(parse_doller '$')
eq 'parse_doller 1' '' $(parse_doller '$a')
eq 'parse_doller 2' '10' $(parse_doller '$(echo 10)')

eq 'parse_list 0' '3' $(parse_list '(add 1 2)')
eq 'parse_list 1' '10' $(parse_list '(add (add (add 1 2) 3) 4)')
eq 'parse_list 2' '202' $(parse_list '(add (sub 3 2) (mul 10 20) (div 3 2))')

eq 'parse 0' '_foo' $(parse '_foo')
eq 'parse 1' 'foo' $(parse 'foo')
eq 'parse 2' 'FOO' $(parse 'FOO')
eq 'parse 3' 'add' $(parse 'add')
eq 'parse 4' 'echo' $(parse 'echo')
eq 'parse 5' '$' $(parse '$') # buggy
eq 'parse 6' '' $(parse '$a') # this variable is not defined
eq 'parse 7' '1' $(parse '$(echo 1)')
eq 'parse 8' '1' $(parse '1')
eq 'parse 9' '3' $(parse '(add 1 2)')
eq 'parse 10' '8' $(parse '(add (sub 10 8) (mul 2 3))')
eq 'parse 11' '2' $(parse '(div $(echo 10) 5)')
eq 'parse 12' '2' $(parse '($(echo div) $(echo 10) 5)')

report
