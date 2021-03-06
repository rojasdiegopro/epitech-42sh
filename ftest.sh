#!/bin/bash

TESTS_PATH=tests/ftests

mkdir $TESTS_PATH 2> /dev/null

NB_TEST_PASSED=0
NB_TEST_FAILED=0
TOTAL_TESTS_PASSED=0
TOTAL_TESTS_FAILED=0
RED='echo -ne \033[38;2;255;50;50m'
GREEN='echo -ne \033[38;2;50;255;50m'
YELLOW='echo -ne \033[38;2;255;255;0m'
WHITE='echo -ne \033[0m'
PURPLE='echo -ne \033[1m\033[038;2;150;150;220m'

function display_test_result() {
    $YELLOW ; echo "$1 result:" ; $WHITE
    $GREEN
    echo -ne "\tTest passed: $NB_TEST_PASSED\n"
    if [ $NB_TEST_FAILED -ne 0 ]
    then
        $RED
        echo -ne "\tTest failed: $NB_TEST_FAILED\n"
    fi
    $WHITE
    TOTAL_TESTS_PASSED=$(($NB_TEST_PASSED + TOTAL_TESTS_PASSED))
    TOTAL_TESTS_FAILED=$(($NB_TEST_FAILED + TOTAL_TESTS_FAILED))
    NB_TEST_PASSED=0
    NB_TEST_FAILED=0
    echo
}

function _test () {
    echo -ne "$1" | $2 ./42sh 2>&1 | $3 | cat > $TESTS_PATH/$4_42sh.ftest
    #$RED; echo "status:$?" ; $WHITE
    echo -ne "$1" | $2 tcsh 2>&1 | $3 | cat > $TESTS_PATH/$4_tcsh.ftest
    difference=`diff $TESTS_PATH/$4_42sh.ftest $TESTS_PATH/$4_tcsh.ftest`
    result=$?
    if [ $result = 0 ]
    then
        $GREEN
        echo $5 OK
        $WHITE
        NB_TEST_PASSED=$((NB_TEST_PASSED + 1))
    else
        $RED
        echo "$5 KO, $TESTS_PATH/$4_42sh.ftest and $TESTS_PATH/$4_tcsh.ftest differ"
        $WHITE
        NB_TEST_FAILED=$((NB_TEST_FAILED + 1))
        echo $difference > $TESTS_PATH/$4_diff.ftest
    fi
}

function basic_test () {
    $PURPLE ; echo "=----= BASIC TESTS =----=" ; $WHITE
    _test '\n\n' "" cat empty "Empty"
    _test '/bin/ls' "" cat run_simple_command "Run simple commands"
    _test '/bin/ls -l' "" cat simple_exec "Simple exec"
    _test 'exitt' "" cat wrong_simple_command "Command not found"
    display_test_result BASIC_TEST
}

function path_handling () {
    $PURPLE ; echo "=----= PATH HANDLING =----=" ; $WHITE
    _test 'unset path\nls' "env -i" cat no_path "No path"
    _test 'bin/ls' "" cat bin_ls_not_found "Bin/ls not found"
    display_test_result PATH_HANDLING
}

function setenv_and_unsetenv () {
    $PURPLE ; echo "=----= SETENV AND UNSETENV =----=" ; $WHITE
    _test 'setenv MASHALLA 1000\nenv\n' "" "grep MASHALLA" setenv "Setenv basic"
    _test 'unsetenv PATH\nenv\n' "" "grep ^PATH=" unsetenv "Unsetenv basic"
    _test 'setenv MASHALLA ¤1' "" "cat" setenv_alphanum "Setenv alphanum error"
    _test 'setenv MASHALLA 1 2' "" "cat" setenv_alphanum "Setenv too many arguments"
    display_test_result SETENV_AND_UNSETENV
}

function builtin_cd () {
    $PURPLE ; echo "=----= BUILTIN CD =----=" ; $WHITE
    _test 'cd\nls' "" "cat" cd_home "Cd"
    _test 'cd ~\nls' "" "cat" cd_tilde "Cd tilde"
    _test 'cd -\nls' "" "cat" cd_minus_no_oldpwd "Cd -, no oldpwd"
    _test 'cd ..\ncd -\nls' "" "cat" cd_minus_with_oldpwd "Cd -, with oldpwd"
    _test 'cd ftest.sh' "" "cat" cd_not_in_directory "Cd not in directroy"
    _test 'cd /root' "" "cat" cd_no_permission "Cd no permissions"
    display_test_result BUILTIN_CD
}

function line_formatting () {
    $PURPLE ; echo "=----= LINE FORMATTING =----=" ; $WHITE
    _test '    ' "" "" "cat" space_1 "Space 1"
    _test '  \n  /bin/echo   \n    /bin/ls   \n' "" "" "cat" space_2 "Space 2"
    _test ' \t   \n  /bin/echo\t \n \t /bin/ls \t   -l \n   ' "" "" "cat" space_and_tab "Space and tab"
    _test '/bin/ls\t-l\t' "" "" "cat" tab "Tab"
    display_test_result LINE_FORMATTING
}

function error_handling () {
    $PURPLE ; echo "=----= ERROR HANDLING =----=" ; $WHITE
    gcc tests/binaries/src/bin_not_compatible.c -o tests/binaries/temp
    tac tests/binaries/temp > tests/binaries/bin_not_compatible
    chmod +x tests/binaries/bin_not_compatible
    gcc ./tests/binaries/src/div_zero.c -o ./tests/binaries/div_zero
    gcc ./tests/binaries/src/segfault.c -o ./tests/binaries/segfault
    _test './tests/binaries/bin_not_compatible' "" "cat" bin_not_compatible "Bin not compatible"
    _test './tests/binaries/div_zero' "" "cat" div_zero "DivZero with core dump"
    _test './tests/binaries/segfault' "" "cat" segfault "SegFault with core dump"
    _test './src' "" "" "cat" exec_directory "Exec a directory"
    display_test_result ERROR_HANDLING
}

function separator () {
    $PURPLE ; echo "=----= SEPARATOR =----=" ; $WHITE
    _test '/bin/ls ; /bin/echo' "" "cat" separator_comma "Separator ';'"
    display_test_result SEPARATOR
}

function simple_pipe () {
    $PURPLE ; echo "=----= SIMPLE PIPE =----=" ; $WHITE
    gcc ./tests/binaries/src/big_file_gen.c -o ./tests/binaries/big_file_gen
    ./tests/binaries/big_file_gen ./tests/binaries/big_file
    _test '/bin/ls | /bin/cat -e' "" "cat" simple_pipe "Simple pipe"
    _test '/bin/cat ./tests/binaries/big_file | wc' "" "cat" pipe_big_input "Pipe with big input"
    _test '/bin/ls | cd ..\nls' "" "cat" pipe_with_builtin_end "Pipe with builtin end"
    _test 'cd .. | /bin/ls\n/bin/ls' "" "cat" pipe_with_builtin_start "Pipe with builtin start"
    _test '/bin/ls | cd .. | /bin/ls\nls' "" "cat" pipe_with_builtin_middle "Pipe with builtin middle"
    display_test_result SIMPLE_PIPE
}

function advanced_pipe () {
    $PURPLE ; echo "=----= ADVANCED PIPE =----=" ; $WHITE
    lot_of_pipe=`cat ./tests/binaries/lot_of_pipe`
    _test 'ouesh ouesh | /bin/cat -e' "" "cat" error_and_pipe_1 "Error and pipe 1"
    _test '/bin/ls | ouesh ouesh' "" "cat" error_and_pipe_2 "Error and pipe 2"
    _test '/bin/ls | ouesh ouesh | cat -e | defzrg | /ls | /bin/ls' "" "cat" multipipe_error "multipipe error"
    _test '/bin/ls | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e | /bin/cat -e' "" "cat" multi_pipe "Multi pipe"
    _test "$lot_of_pipe" "" "cat" fd_max "Pipe fd max"
    _test '|' "" "cat" only_a_pipe "Only a pipe"
    display_test_result ADVANCED_PIPE
}

function redirections () {
    $PURPLE ; echo "=----= REDIRECTIONS =----=" ; $WHITE
    _test 'ls > tests/binaries/redirection_test \ncat tests/binaries/redirection_test' "" cat redirections_simple_right "simple right redirection"
    _test 'ls > tests/binaries/redirection_test\nls >> tests/binaries/redirection_test\nls >> tests/binaries/redirection_test\n \ncat tests/binaries/redirection_test' "" cat redirections_double_right "double right redirection"
    _test 'cat < tests/binaries/div_zero.c' "" cat redirections_simple_left "simple left redirection"
    _test 'cat < tests/binaries/div_zero.c > tests/binaries/left_and_right\ncat tests/binaries/left_and_right' "" cat redirections_simple_left_then_right "simple left then right redirection"
    _test 'cat < MASHALLA' "" "cat" bad_redirection_left "Bad redirection left"
    _test 'ls > tests/' "" "cat" bad_redirection_right_directory "Bad redirection right (directory)"
    _test 'ls >' "" "cat" missing_name_redirect "Missing name for redirect"
    _test 'cat < cat < Makefile' "" "cat" ambiguous_redirect "Ambiguous input redirect"
    display_test_result REDIRECTIONS
}

function advanced_manipulations () {
    $PURPLE ; echo "=----= ADVANCED MANIPULATIONS =----=" ; $WHITE
    _test './42sh\nls' "" "cat" running_42sh_in_42sh "Running 42sh inside 42sh"
    display_test_result ADVANCED_MANIPULATIONS
}

function AND_and_OR_tests () {
    $PURPLE ; echo "=----= && AND || TESTS =----=" ; $WHITE
    _test 'ls && ls' "" cat AND_and_OR1 "AND simple test"
    _test 'ls || ls' "" cat AND_and_OR2 "OR simple test"
    _test 'ls || ls && ls' "" cat AND_and_OR3 "OR and AND advanced test 1"
    _test 'ls || ls && ls && jfweiji || cat telpw && grep' "" cat AND_and_OR4 "OR and AND advanced test 2"
    _test 'ls aerz || echo && ls' "" "cat" AND_and_OR5 "OR and AND 5"
    _test 'ls && ls && ls && ls || ls || ls && ls' "" "cat" AND_and_OR6 "OR and AND 6"
    _test 'ls || ls && ls || ls' "" "cat" AND_and_OR7 "OR and AND 7"
    _test 'ls aef || ls && ls azer' "" "cat" AND_and_OR8 "OR and AND 8"
    _test 'true && false || true && true' "" "cat" AND_and_OR9 "OR and AND 9"
    _test 'false || true && true' "" "cat" AND_and_OR10 "OR and AND 10"
    display_test_result AND_and_OR_TESTS
}

function globbing () {
    $PURPLE ; echo "=----= GLOBBING =----=" ; $WHITE
    _test 'ls ?ests' "" cat globbing1 "? globbing"
    _test 'ls [a-z]ests' "" cat globbing2 "[] globbing"
    _test 'ls [a-z]rew' "" cat globbing3 "error globbing"
    _test 'ls *' "" cat globbing4 "'*' globbing"
    display_test_result GLOBBING
}

function var_interpreter () {
    $PURPLE ; echo "=----= VAR INTERPRETER =----=" ; $WHITE
    _test 'echo $PATH' "" cat display_path "Display path"
    _test 'echo $INVALID' "" cat bad_var "Bad var"
    display_test_result GLOBBING
}

function inhibitor () {
    $PURPLE ; echo "=----= INHIBITOR =----=" ; $WHITE
    _test 'echo \"' "" cat echo_quote1 "Echo quote"
    _test 'echo \' "" cat echo_quote2 "Echo single \\"
    display_test_result INHIBITOR
}

function magic_quote() {
    $PURPLE ; echo "=----= MAGIC QUOTE =----=" ; $WHITE
    _test 'echo `python -c "print '"'A'"'*10"`' "" cat python_script "Python script"
    _test 'echo `echo $PATH`' "" cat variable_in_back_quote "Variable in back quote"
    _test 'echo `tac src/main.c | cat -e`' "" cat pipe_in_back_quote "Pipe in back quote"
    display_test_result MAGIC_QUOTE
}

function _alias () {
    $PURPLE ; echo "=----= ALIAS =----=" ; $WHITE
    _test 'alias lol ls \n lol' "" cat _alias1 "basic alias"
    _test 'alias lol=ls \n lol' "" cat _alias2 "error alias 1"
    _test 'alias lolle eqwo \n lollle' "" cat _alias3 "error alias 2"
    _test 'alias a b\nalias b a\nb' "" cat _alias4 "alias loop"
    display_test_result _ALIAS
}

function scripting () {
    $PURPLE ; echo "=----= SCRIPTING =----=" ; $WHITE
    display_test_result SCRIPTING
}

function _foreach () {
    $PURPLE ; echo "=----= FOREACH =----=" ; $WHITE
    _test 'foreach f (1 543 5) \n echo $f \n end' "" cat _foreach1 "basic foreach"
    _test 'foreach f (1) \n if($f) ls \n end' "" cat _foreach2 "combined with if foreach"
    display_test_result _FOREACH
}

function _which () {
    $PURPLE ; echo "=----= WHICH =----=" ; $WHITE
    _test 'unalias ls \n which ls' "" cat _which1 "basic where"
    _test 'which fewijpfow fpwokefew' "" cat _which2 "where error handling"
    _test 'unalias ls \n which ls' "" cat _which3 "builtin where"
    display_test_result _WHICH
}

function _where () {
    $PURPLE ; echo "=----= WHERE =----=" ; $WHITE
    _test 'unalias ls \n where ls' "" cat _where1 "basic where"
    _test 'where fewijpfow fpwokefew' "" cat _where2 "where error handling"
    _test 'unalias ls \n where ls' "" cat _where3 "builtin where"
    display_test_result _WHERE
}

function _if () {
    $PURPLE ; echo "=----= IF =----=" ; $WHITE
    _test 'if(1) ls' "" cat _if1 "basic if"
    _test 'if ($?) ls' "" cat _if2 "if with variable"
    _test 'if(0) ls' "" cat _if3 "null if"
    display_test_result _IF
}

function _repeat () {
    $PURPLE ; echo "=----= REPEAT =----=" ; $WHITE
    _test 'repeat 4 ls' "" cat repeat1 "basic repeat"
    _test 'repeat -1 ls' "" cat repeat2 "negative repeat"
    _test 'repeat 0 ls' "" cat repeat3 "null repeat"
    display_test_result _REPEAT
}

function parenthesis () {
    $PURPLE ; echo "=----= PARENTHESIS =----=" ; $WHITE
    _test '(ls | cat)' "" cat parenthesis1 "basic parenthesis"
    _test '(ls | cat) | grep test' "" cat parenthesis2 "parenthesis with something after"
    _test 'ls | (grep toto | cat)' "" cat parenthesis3 "parenthesis at the end"
    display_test_result PARENTHESIS
}

function personnals () {
    $PURPLE ; echo "=----= PERSONNALS =----=" ; $WHITE
    _test '/bin/ls' "env -i" cat ls "Basic test ls"
    _test '/bin/cd ..\n/bin/ls' "env -i"  cat cd "Basic test cd"
    _test 'setenv' "env -i" cat env "Basic test env"
    _test 'setenv MDR 100\nsetenv | /usr/bin/grep MDR' "env -i" cat setenv "Basic test setenv"
    _test 'unsetenv PATH\nsetenv | /usr/bin/grep PATH' "" cat unsetenv "Basic test unsetenv"
    _test 'alias this_is_an_alias b && alias | grep this_is_an_alias' "" cat alias "Basic test alias"
    _test 'repeat 5 /bin/ls' "env -i" cat repeat "Basic test repeat"
    _test 'if (1) /bin/ls' "env -i" cat if10 "Basic test if"
    _test 'foreach f (1 2 3)\necho 1 + $f\nend\n' "" cat foreach "Basic test foreach"
    _test '/bin/ls > ls_output\n/bin/cat ls_output\n/usr/bin/rm ls_output' "" cat simple_right_redir "Basic test simple right redir"
    _test '/bin/ls >> ls_output\n/bin/ls >> ls_output\n/bin/cat ls_output\n/usr/bin/rm ls_output' "" cat double_right_redir "Basic test double right redir"
    display_test_result PERSONNALS
}

function randoms_tests () {
    $PURPLE ; echo "=----= RANDOMS_TESTS =----=" ; $WHITE
    _test 'cd ; </etc/hosts od -c | grep xx | wc >> /tmp/z -l ; cd - && echo "OK"' "" cat subject_test "subject test"
    _test 'jfeaoj && ls || cat test' "" cat big_multiple_test1 "big multiple test1"
    _test 'ls ; cat < | ls || grep' "" cat big_multiple_test2 "big multiple test2"
    _test '                  ls;                       ls | grep sr || echo FAILED' "" cat big_multiple_test3 "big multiple test3"
    _test '|' "" cat big_multiple_test4 "big multiple test4"
    _test '&' "" cat big_multiple_test5 "big multiple test5"
    _test '&& ||' "" cat big_multiple_test6 "big multiple test6"
    _test 'ls&&ls' "" cat big_multiple_test7 "big multiple test7"
    _test 'zbeub || zbeub || ls | cat | grep sr' "" cat big_multiple_test8 "big multiple test8"
    _test 'cd test ; ls -a ; ls | cat | wc -c > tutu ; cat tutu' "" cat minishell2_subject_test "minishell 2 subject test"
    display_test_result RANDOMS_TESTS
}

function total () {
    $PURPLE ; echo "TOTAL" ; $WHITE
    $GREEN
    echo -ne "\tTest passed: $TOTAL_TESTS_PASSED\n"
    $RED
    echo -ne "\tTest failed: $TOTAL_TESTS_FAILED\n"
    $WHITE
    nb_test=$((TOTAL_TESTS_PASSED + TOTAL_TESTS_FAILED))
    percentage=$((TOTAL_TESTS_PASSED * 100 / nb_test))
    for i in {1..10}
    do
        if [ $i -lt $((percentage / 10)) ]
        then
            $GREEN ; echo -ne '♥ ' ; $WHITE
        else
            $PURPLE ; echo -ne '♥ ' ; $WHITE
        fi
    done
    $PURPLE ; echo "$percentage%" ; $WHITE
}

function all () {
    basic_test
    path_handling
    setenv_and_unsetenv
    builtin_cd
    line_formatting
    error_handling
    separator
    simple_pipe
    advanced_pipe

    personnals
    parenthesis
    _repeat
    _if
    _where
    _which
    _foreach
    _alias
    globbing
    AND_and_OR_tests
    redirections
    randoms_tests

    total
}

function clean () {
    rm -f ./tests/binaries/*
    rm -f ./tests/ftests/*.ftest
}

if [ $1 ]
then
    $1
else
    all
fi
