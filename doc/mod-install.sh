#!/bin/sh

col_pname="[33m"
col_error="[31m"
col_info="[32m"
col_info2="[32m"
col_rst="[0m"

echo "${col_info}Re-run this script to update (from Github) and rebuild the module.$col_rst"

#
# Clone or pull
#

ZINIT_HOME="${ZINIT_HOME:-${ZPLG_HOME:-${ZDOTDIR:-${HOME}}/.zinit}}"
ZINIT_MOD_BIN_DIR_NAME="mod-bin"

if ! test -d "$ZINIT_HOME/$ZINIT_MOD_BIN_DIR_NAME"; then
    mkdir -p "$ZINIT_HOME/$ZINIT_MOD_BIN_DIR_NAME"
    chmod g-rwX "$ZINIT_HOME/$ZINIT_MOD_BIN_DIR_NAME"
fi

echo ">>> Downloading zshell/zplugin module to $ZINIT_HOME/$ZINIT_MOD_BIN_DIR_NAME"
if test -d "$ZINIT_HOME/$ZINIT_MOD_BIN_DIR_NAME/.git"; then
    cd "$ZINIT_HOME/$ZINIT_MOD_BIN_DIR_NAME" || return
    git pull origin main
else
    cd "$ZINIT_HOME" || return
    git clone --depth 10 https://github.com/z-shell/zinit.git "$ZINIT_MOD_BIN_DIR_NAME"
fi
echo ">>> Done"

#
# Build the module
#

cd "$ZINIT_HOME/$ZINIT_MOD_BIN_DIR_NAME/zmodules" || return
echo "$col_pname== Building module zshell/zplugin, running: a make clean, then ./configure and then make ==$col_rst"
echo "$col_pname== The module sources are located at: $ZINIT_HOME/$ZINIT_MOD_BIN_DIR_NAME/zmodules ==$col_rst"
test -f Makefile && {
    [ "$1" = "--clean" ] && {
        echo "$col_info2-- make distclean --$col_rst"
        make distclean
        true
    } || {
        echo "$col_info2-- make clean (pass --clean to invoke \`make distclean') --$col_rst"
        make clean
    }
}
echo "$col_info2-- ./configure --$col_rst"
CPPFLAGS=-I/usr/local/include CFLAGS="-g -Wall -O3" LDFLAGS=-L/usr/local/lib ./configure --disable-gdbm --without-tcsetpgrp && {
    echo "$col_info2-- make --$col_rst"
    make && {
        echo "${col_info}Module has been built correctly.$col_rst"
        echo "To load the module, add following 2 lines to .zshrc, at top:"
        echo "    module_path+=( \"$ZINIT_HOME/$ZINIT_MOD_BIN_DIR_NAME/zmodules/Src\" )"
        echo "    zmodload zshell/zplugin"
        echo ""
        echo "After loading, use command \`zpmod' to communicate with the module."
        echo "See \`zpmod -h' for more information. There are two main features,"
        echo "invocation of \`zpmod source-study' which shows \`source' profile"
        echo "data, and guaranteed, automatic compilation of any sourced script"
        echo "while the module is loaded (check with Zsh command \`zmodload')."
    } || {
        echo "${col_error}Module didn't build.$col_rst. You can copy the error messages and submit"
        echo "error-report at: https://github.com/z-shell/zinit/issues"
    }
}
