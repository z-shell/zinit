#!/usr/bin/env zsh

local emul="zsh";
[[ -f ./emulate ]] && emul="$(<./emulate)"
emul="${5:-$emul}"
emulate -LR "$emul" -o warncreateglobal -o typesetsilent -o extendedglob

local opts="$6"

# Will generate new answer
[[ -d $PWD/$1/answer ]] && rm -rf $PWD/$1/answer

unset ZCONVEY_LOCKS_DIR ZCONVEY_IO_DIR
# Discard per-setup (e.g. per-version) PATH and FPATH entries
builtin autoload +X is-at-least
builtin autoload +X allopt
builtin autoload +X add-zsh-hook
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin
FPATH=/usr/share/zsh/site-functions:/usr/local/share/zsh/functions:/usr/local/share/zsh/site-functions
LANG=C
LC_ALL=C

local TEST_DIR="$PWD/$1"

# Setup paths and load zinit
local REPLY p k l ll
local -a reply
local -A ZPLGM
ZPLGM[BIN_DIR]=$PWD
command mkdir -p $PWD/$1/answer
ZPLGM[HOME_DIR]=$PWD/$1/answer
builtin source "${ZPLGM[BIN_DIR]}/zinit.zsh"
command mkdir $PWD/$1/answer/snippets/OMZ::plugins

# FUNCTION: internet_mock_git {{{
internet_mock_git() {
    setopt localoptions extendedglob warncreateglobal typesetsilent
    local -A opts
    local -a args
    args=( "$@" )

    builtin zparseopts -E -D -A opts -recursive -progress -depth: || { echo "Incorrect options given to git mock function"; return 1; }

    if [[ "$1" = "clone" ]]; then
        local -A urlmap
        urlmap=( "${(f@)"$(<$TEST_DIR/urlmap)"}" )
        urlmap=( "${(kv)urlmap[@]//\%PWD/$TEST_DIR}" )
        local URL="$2"
        URL="${urlmap[$URL]}"
        local local_dir="$3"

        command git clone ${opts[--progress]+--progress} ${opts[--recursive]+--recursive} ${=opts[--depth]+--depth ${opts[--depth]}} "$URL" "$local_dir"
    elif [[ "$1" = "fetch" ]]; then
        shift
        command git fetch "$@"
    elif [[ "$1" = "pull" ]]; then
        shift
        command git pull "$@"
    elif [[ "$1" = "log" ]]; then
        shift
        command git log "$@"
    else
        builtin print "Incorrect command ($1) given to the git mock, the mock exits with error"
        builtin return 1
    fi

    builtin return 0
}
# }}}
# FUNCTION: internet_mock_svn {{{
internet_mock_svn() {
    setopt localoptions extendedglob warncreateglobal typesetsilent
    local -A opts
    local -a args
    args=( "$@" )

    builtin zparseopts -E -D -A opts -non-interactive q || { echo "Incorrect options given to SVN mock function"; return 1; }

    if [[ "$1" = "checkout" ]]; then
        local -A urlmap
        urlmap=( "${(f@)"$(<$TEST_DIR/urlmap)"}" )
        urlmap=( "${(kv)urlmap[@]//\%PWD/$TEST_DIR}" )
        local URL="$2"
        local local_dir="${URL:t}"
        URL="${urlmap[$URL]}"
        URL="${URL//\/[^\/]##\/../}"

        [[ -z "$URL" ]] && {
            print -u2 -r -- "### internet_mock_svn: urlmap didn't contain \`$2'"
            return 1
        }

        command svn checkout ${opts[--non-interactive]+--non-interactive} ${opts[-q]+-q} "$URL" "$local_dir"
        return $?
    elif [[ "$1" = "update" ]]; then
        shift
        command svn update "$@"
        return $?
    else
        builtin print "Incorrect command ($1) given to the SVN mock, the mock exits with error"
        builtin return 1
    fi

    builtin return 0
}
# }}}
# FUNCTION: internet_mock_curl {{{
internet_mock_curl() {
    setopt localoptions extendedglob warncreateglobal typesetsilent
    local -a opts
    local -a args
    args=( "$@" )

    builtin zparseopts -E -D -a opts f s S L || { echo "Incorrect options given to CURL mock function"; return 1; }
    local -a all_opts
    all_opts=( -f -s -S -L )

    if [[ -z ${(@)opts:|all_opts} ]]; then
        local -A urlmap
        urlmap=( "${(f@)"$(<$TEST_DIR/urlmap)"}" )
        urlmap=( "${(kv)urlmap[@]//\%PWD/$TEST_DIR}" )
        local URL="$1"
        local local_dir="${URL:t}"
        URL="${urlmap[$URL]}"
        URL="${URL//\/[^\/]##\/../}"

        [[ -z "$URL" ]] && {
            print -u2 -r -- "### internet_mock_curl: urlmap didn't contain \`$1'"
            return 1
        }

        command curl ${opts[@]} "$URL"
        return $?
    fi

    return 1
}
# }}}
# FUNCTION: verbosity {{{
tst_verbosity() {
    # 3 can be used for output
    exec 3<&1

    if (( VERBOSE )); then
        : # no redirection
    elif (( DBG )); then
        exec 1>/dev/null
    else
        exec 1>/dev/null
        exec 2>&1
    fi
}
# }}}
# FUNCTION: no_colors {{{
no_colors() {
    local -A mymap
    mymap=( "${(kv)ZPLGM[@]}" )
    local -a keys
    keys=( ${mymap[(I)*(col-)*]} )

    for k in "${keys[@]}"; do
        ZPLGM[$k]=""
    done
}
# }}}
# FUNCTION: store_state {{{
store_state() {
    setopt localoptions extendedglob nokshglob noksharrays
    local out="$1" out2="$2"
    (( ${+functions[-zplg-diff-env-compute]} )) || builtin source ${ZPLGM[BIN_DIR]}"/zinit-autoload.zsh"

    local -A not_show_keys
    not_show_keys=( UPAR 1 DOWNAR 1 RIGHTAR 1 LEFTAR 1 \
            FUNCTIONS_BEFORE__\* 1 FUNCTIONS_AFTER__\* 1 \
            PARAMETERS_BEFORE__\* 1 PARAMETERS_AFTER__\* 1
            OPTIONS_BEFORE__\* 1 OPTIONS_AFTER__\* 1
            FPATH_BEFORE__\* 1 FPATH_AFTER__\* 1
            PATH_BEFORE__\* 1 PATH_AFTER__\* 1
            BINDKEYS__\* 1
        )

    local -A mymap
    mymap=( "${(kv)ZPLGM[@]}" )
    local -a keys
    keys=( ${mymap[(I)*(col-)*]} NEW_AUTOLOAD )

    for k in "${keys[@]}"; do
        unset "ZPLGM[$k]"
    done

    keys=( ${(k)mymap[(R)[[:digit:]]##.[[:digit:]]#]} )
    for k in "${keys[@]}"; do
        ZPLGM[$k]="__reset-by-test__"
    done

    ZPLGM[EXTENDED_GLOB]=""

    ZPLGM=( "${(kv)ZPLGM[@]/${PWD:h}\//}" )
    ZPLGM=( "${(kv)ZPLGM[@]/${${PWD:h}:h}\//}" )

    # Sort and print
    for k in "${(ko)ZPLGM[@]}"; do
        [[ -n "${not_show_keys[(k)$k]}" ]] && continue
        local -a arr
        arr=( "${(z@)ZPLGM[$k]}" )
        local val="${(j: :o)arr}"
        print -rl -- "$k" "$val" >>! "$out"
    done

    print -r -- "---" >>! "$out"

    print -r -- "ERRORS" >! "$out2"

    # Normalize PATH and FPATH
    local -a path2 fpath2
    path=( "${path[@]/${PWD:h}\//}" )
    path=( "${path[@]/${${PWD:h}:h}\//}" )
    fpath=( "${fpath[@]/${${PWD:h}:h}\//}" )
    fpath=( "${fpath[@]/${PWD:h}\//}" )

    for k in "${ZPLG_REGISTERED_PLUGINS[@]}"; do
        -zplg-diff-functions-compute "$k" || print -r -- "Failed: -zplg-diff-functions-compute for $k" >>! "$out2"
        -zplg-diff-options-compute "$k"   || print -r -- "Failed: -zplg-diff-options-compute for $k" >>! "$out2"
        -zplg-diff-env-compute "$k"       || print -r -- "Failed: -zplg-diff-env-compute $k" >>! "$out2"
        -zplg-diff-parameter-compute "$k" || print -r -- "Failed: -zplg-diff-parameter-compute $k" >>! "$out2"
    done

    print -r -- "ZPLG_REGISTERED_PLUGINS:${${:- ${(qq@)ZPLG_REGISTERED_PLUGINS}}:# }" >>! "$out"

    keys=( ZPLG_REGISTERED_STATES ZPLG_SNIPPETS ZPLG_SICE )

    for k in "${keys[@]}"; do
        [[ "${(ok@)#${(Pk@)k}}" -gt 0 ]] && print -rn -- "$k:" >>! "$out" || print -rn -- "$k: " >>! "$out"
        # (k) two times, outer for after patch, the inner one for before-patch:
        # 37092: make nested ${(P)name} properly refer to parameter on return
        for l in ${(ok@)${(Pk@)k}}; do
            ll="$k"; ll+="[$l]"
            print -rn -- ${:- ${(qq)l} ${(Pqq)ll}} >>! "$out"
        done
        print >>! "$out"
    done
    print
    [[ -n "$ZPLG_COMPDEF_REPLAY" ]] && print -r -- "ZPLG_COMPDEF_REPLAY: ${(qq@)ZPLG_COMPDEF_REPLAY}" >>! "$out" || print -r -- "ZPLG_COMPDEF_REPLAY: " >>! "$out"
    print -r -- "ZPLG_CUR_PLUGIN: ${(qq)ZPLG_CUR_PLUGIN}" >>! "$out"

    print -rl -- "---" "Parameter module: ${+modules[zsh/parameter]}" >>! "$out"
}
# }}}

no_colors

builtin cd "$1"
[[ -n "$2" ]] && typeset -g VERBOSE=1     # $(VERBOSE)
[[ -n "$3" ]] && typeset -g DBG=1         # $(DEBUG)
[[ -n "$4" ]] && { allopt > allopt.txt; } # $(OPTDUMP)

local -a plugins
[[ -f "plugins" ]] && plugins=( "${(@f)"$(<./plugins)"}" )
for p in "${plugins[@]}"; do
    [[ ! -e ../test_plugins/$p/.git ]] && command ln -sf .test_git ../test_plugins/$p/.git
done

command rm -f skip
[[ -n "$opts" ]] && setopt ${=opts}
builtin source ./script || echo "Test's script has failed" > answer/fail.msg
[[ -n "$opts" ]] && unsetopt ${=opts}

for p in "${plugins[@]}"; do
    command rm -f ../test_plugins/$p/.git
done

local -a execs
execs=( ./answer/**/*(*N) )
for k in "${execs[@]}"; do
    print -r -- "The file has a +x permission" >! ${k}.is_exec
done

store_state answer/state answer/errors

return 0
