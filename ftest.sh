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

function display_test_result() {
    $YELLOW ; echo "$1 result:" ; $WHITE
    $GREEN
    echo -ne "\tTest passed: $NB_TEST_PASSED\n"
    $RED
    echo -ne "\tTest failed: $NB_TEST_FAILED\n"
    $WHITE
    TOTAL_TESTS_PASSED=$(($NB_TEST_PASSED + TOTAL_TESTS_PASSED))
    TOTAL_TESTS_FAILED=$(($NB_TEST_FAILED + TOTAL_TESTS_FAILED))
    NB_TEST_PASSED=0
    NB_TEST_FAILED=0
}

function _test () {
    echo -ne "$1" | $2 ./42sh 2>&1 | $3 | cat > $TESTS_PATH/$4_42sh.ftest
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
    $YELLOW ; echo "=----= BASIC TESTS =----=" ; $WHITE
    _test '\n\n' "" cat empty "Empty"
    _test '/bin/ls' "" cat run_simple_command "Run simple commands"
    _test '/bin/ls -l' "" cat simple_exec "Simple exec"
    _test 'exitt' "" cat wrong_simple_command "Command not found"
    display_test_result BASIC_TEST
}

function path_handling () {
    $YELLOW ; echo "=----= PATH HANDLING =----=" ; $WHITE
    _test 'unset path\nls' "env -i" cat no_path "No path"
    _test 'bin/ls' "" cat bin_ls_not_found "Bin/ls not found"
    display_test_result PATH_HANDLING
}

function setenv_and_unsetenv () {
    $YELLOW ; echo "=----= SETENV AND UNSETENV =----=" ; $WHITE
    _test 'setenv MASHALLA 1000\nenv\n' "" "grep MASHALLA" setenv "Setenv basic"
    _test 'unsetenv PATH\nenv\n' "" "grep ^PATH=" unsetenv "Unsetenv basic"
    _test 'setenv MASHALLA ¤1' "" "cat" setenv_alphanum "Setenv alphanum error"
    _test 'setenv MASHALLA 1 2' "" "cat" setenv_alphanum "Setenv too many arguments"
    display_test_result SETENV_AND_UNSETENV
}

function builtin_cd () {
    $YELLOW ; echo "=----= BUILTIN CD =----=" ; $WHITE
    _test 'cd\nls' "" "cat" cd_home "Cd"
    _test 'cd ~\nls' "" "cat" cd_tilde "Cd tilde"
    _test 'cd -\nls' "" "cat" cd_minus_no_oldpwd "Cd -, no oldpwd"
    _test 'cd ..\ncd -\nls' "" "cat" cd_minus_with_oldpwd "Cd -, with oldpwd"
    _test 'cd ftest.sh' "" "cat" cd_not_in_directory "Cd not in directroy"
    _test 'cd /root' "" "cat" cd_no_permission "Cd no permissions"
    display_test_result BUILTIN_CD
}

function line_formatting () {
    $YELLOW ; echo "=----= LINE FORMATTING =----=" ; $WHITE
    _test '    ' "" "" "cat" space_1 "Space 1"
    _test '  \n  /bin/echo   \n    /bin/ls   \n' "" "" "cat" space_2 "Space 2"
    _test ' \t   \n  /bin/echo\t \n \t /bin/ls \t   -l \n   ' "" "" "cat" space_and_tab "Space and tab"
    _test '/bin/ls\t-l\t' "" "" "cat" tab "Tab"
    display_test_result LINE_FORMATTING
}

function error_handling () {
    $YELLOW ; echo "=----= ERROR HANDLING =----=" ; $WHITE
    cp ./tests/binaries/bin_not_compatible.c ./tests/binaries/bin_not_compatible
    chmod +x ./tests/binaries/bin_not_compatible
    gcc ./tests/binaries/div_zero.c -o ./tests/binaries/div_zero
    gcc ./tests/binaries/segfault.c -o ./tests/binaries/segfault
    _test './tests/binaries/bin_not_compatible' "" "cat" bin_not_compatible "Bin not compatible"
    _test './tests/binaries/div_zero' "" "cat" div_zero "DivZero with core dump"
    _test './tests/binaries/segfault' "" "cat" segfault "SegFault with core dump"
    _test './src' "" "" "cat" exec_directory "Exec a directory"
    display_test_result ERROR_HANDLING
}

function separator () {
    $YELLOW ; echo "=----= SEPARATOR =----=" ; $WHITE
    _test '/bin/ls ; /bin/echo' "" "cat" separator_comma "Separator ';'"
    display_test_result SEPARATOR
}

function simple_pipe () {
    $YELLOW ; echo "=----= SIMPLE PIPE =----=" ; $WHITE
    _test '/bin/ls | /cat -e' "" "cat" simple_pipe "Simple pipe"
    display_test_result SIMPLE_PIPE
}

function advanced_pipe () {
    $YELLOW ; echo "=----= ADVANCED PIPE =----=" ; $WHITE
    display_test_result ADVANCED_PIPE
}

function redirections () {
    $YELLOW ; echo "=----= REDIRECTIONS =----=" ; $WHITE
    display_test_result REDIRECTIONS
}

function advanced_manipulations () {
    $YELLOW ; echo "=----= ADVANCED MANIPULATIONS =----=" ; $WHITE
    display_test_result ADVANCED_MANIPULATIONS
}

function AND_and_OR_tests () {
    $YELLOW ; echo "=----= && AND || TESTS =----=" ; $WHITE
    display_test_result AND_and_OR_TESTS
}

function globbing () {
    $YELLOW ; echo "=----= GLOBBING =----=" ; $WHITE
    display_test_result GLOBBING
}

function var_interpreter () {
    $YELLOW ; echo "=----= VAR INTERPRETER =----=" ; $WHITE
    display_test_result GLOBBING
}

function inhibitor () {
    $YELLOW ; echo "=----= INHIBITOR =----=" ; $WHITE
    display_test_result INHIBITOR
}

function magic_quote() {
    $YELLOW ; echo "=----= MAGIC QUOTE =----=" ; $WHITE
    display_test_result MAGIC_QUOTE
}

function _alias () {
    $YELLOW ; echo "=----= ALIAS =----=" ; $WHITE
    display_test_result ALIAS
}

function scripting () {
    $YELLOW ; echo "=----= SCRIPTING =----=" ; $WHITE
    display_test_result SCRIPTING
}

function _foreach () {
    $YELLOW ; echo "=----= FOREACH =----=" ; $WHITE
    _test 'foreach f (1 543 5) \n echo $f \n end' "" cat repeat "basic foreach"
    _test 'foreach f (1) \n if($f) ls \n end' "" cat repeat "combined with if foreach"
    display_test_result _FOREACH
}

function _which () {
    $YELLOW ; echo "=----= WHICH =----=" ; $WHITE
    _test 'unalias ls \n which ls' "" cat repeat "basic where"
    _test 'which fewijpfow fpwokefew' "" cat repeat "where error handling"
    _test 'unalias ls \n which ls' "" cat repeat "builtin where"
    display_test_result _WHICH
}

function _where () {
    $YELLOW ; echo "=----= WHERE =----=" ; $WHITE
    _test 'unalias ls \n where ls' "" cat repeat "basic where"
    _test 'where fewijpfow fpwokefew' "" cat repeat "where error handling"
    _test 'unalias ls \n where ls' "" cat repeat "builtin where"
    display_test_result _WHERE
}

function _if () {
    $YELLOW ; echo "=----= IF =----=" ; $WHITE
    _test 'if(1) ls' "" cat repeat "basic if"
    _test 'if ($?) ls' "" cat repeat "if with variable"
    _test 'if(0) ls' "" cat repeat "null if"
    display_test_result _IF
}

function _repeat () {
    $YELLOW ; echo "=----= REPEAT =----=" ; $WHITE
    _test 'repeat 4 ls' "" cat repeat "basic repeat"
    _test 'repeat -1 ls' "" cat repeat "negative repeat"
    _test 'repeat 0 ls' "" cat repeat "null repeat"
    display_test_result _REPEAT
}

function parenthesis () {
    $YELLOW ; echo "=----= PARENTHESIS =----=" ; $WHITE
    _test '(ls | cat)' "" cat parenthesis "basic parenthesis"
    _test '(ls | cat) | grep test' "" cat parenthesis "parenthesis with something after"
    _test 'ls | (grep toto | cat)' "" cat parenthesis "parenthesis at the end"
    display_test_result PARENTHESIS
}

function personnals () {
    $YELLOW ; echo "=----= PERSONNALS =----=" ; $WHITE
    _test '/bin/ls' "env -i" cat ls "Basic test ls"
    _test '/bin/cd ..\n/bin/ls' "env -i"  cat cd "Basic test cd"
    _test 'setenv' "env -i" cat env "Basic test env"
    _test 'setenv MDR 100\nsetenv | /usr/bin/grep MDR' "env -i" cat setenv "Basic test setenv"
    _test 'unsetenv PATH\nsetenv | /usr/bin/grep PATH' "" cat unsetenv "Basic test unsetenv"
    _test 'alias this_is_an_alias b && alias | grep this_is_an_alias' "" cat alias "Basic test alias"
    _test 'repeat 5 /bin/ls' "env -i" cat repeat "Basic test repeat"
    _test 'if (1) /bin/ls' "env -i" cat if "Basic test if"
    _test 'foreach f (1 2 3)\necho 1 + $f\nend\n' "" cat foreach "Basic test foreach"
    _test '/bin/ls > ls_output\n/bin/cat ls_output\n/usr/bin/rm ls_output' "" cat simple_right_redir "Basic test simple right redir"
    _test '/bin/ls >> ls_output\n/bin/ls >> ls_output\n/bin/cat ls_output\n/usr/bin/rm ls_output' "" cat double_right_redir "Basic test double right redir"
    display_test_result PERSONNALS
}

function all () {
    basic_test
    path_handling
    setenv_and_unsetenv
    builtin_cd
    line_formatting
    error_handling
    separator

    personnals
    parenthesis
    _repeat
    _if
    _where
    _which
    _foreach

    NB_TEST_PASSED=$TOTAL_TESTS_PASSED
    NB_TEST_FAILED=$TOTAL_TESTS_FAILED
    display_test_result TOTAL
}

function clean () {
    rm -f ./tests/binaries/bin_not_compatible
    rm -f ./tests/binaries/divzero
    rm -f ./tests/binaries/segfault
    rm -f ./tests/ftests/*.ftest
}

if [ $1 ]
then
    $1
else
    all
fi
