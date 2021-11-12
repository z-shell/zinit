<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

**Table of Contents** _generated with [DocToc](https://github.com/thlorenz/doctoc)_

- [Changelog](#changelog)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Changelog

All notable changes to this project will be documented in this file.

- 21-01-2020

  - A few tips for the project rename following the field reports (the issues created
    by users):
    - the `ZPLGM` hash is now `ZINIT`,
    - the annexes are moved under [z-shell](https://github.com/z-shell)
      organization (it needs a logo, could you create one, if you're skilled in
      graphics?).

- 15-01-2020

  - There's a new function, `zpextract`, which unpacks the given file. It supports many
    formats (notably also `dmg` images) – if there's a format that's unsupported please
    don't hesitate to [make a
    request](https://github.com/z-shell/zinit/issues/new?template=feature_request.md)
    for it to be added. A few facts:
    - the function is available only at the time of the plugin/snippet installation,
    - it's to be used within `atclone` and `atpull` ices,
    - it has an optional `--move` option which moves all the files from a subdirectory
      up one level,
    - one other option `--norm` prevents the archive from being deleted upon unpacking.
  - snippets now aren't re-downloaded unless they're newer on the HTTP server; use
    this with the `--norm` option of `zpextract` to prevent unnecessary updates; for
    example, the [firefox-dev package](https://github.com/Zsh-Packages/firefox-dev)
    uses this option for this purpose,
  - GitHub doesn't report proper `Last-Modified` HTTP server for the files in the
    repositories so the feature doesn't yet work with such files.

- 13-12-2019

  - The packages have been disconnected from NPM registry and now live only on Zsh
    Packages organization. Publishing to NPM isn't needed.
  - There are two interesting packages,
    [any-gem](https://github.com/Zsh-Packages/any-gem) and
    [any-node](https://github.com/Zsh-Packages/any-node). They allow to install any
    Gem(s) or Node module(s) locally in a newly created plugin directory. For example:

    ```zsh
    zinit pack param='GEM -> rails' for any-gem
    zinit pack param='MOD -> doctoc' for any-node
    # To have the command in zshrc, add an id-as'' ice so that
    # Zinit knows that the package is already installed
    # (also: the Unicode arrow is allowed)
    zinit id-as=jekyll pack param='GEM → jekyll' for any-gem
    ```

    The binaries will be exposed without altering the PATH via shims
    ([Bin-Gem-Node](https://github.com/zinit-zsh/z-a-bin-gem-node) annex is needed).
    Shims are correctly removed when deleting a plugin with `zinit delete …`.

- 11-12-2019

  - Zinit now supports installing special-Zsh NPM packages! Bye-bye the long and
    complex ice-lists! Check out the
    [Wiki](http://z-shell.org/zinit/wiki/NPM-Packages/) for an introductory document
    on the feature.

- 25-11-2019

  - A new subcommand `run` that executes a command in the given plugin's directory. It
    has an `-l` option that will reuse the previously provided plugin. So that it's
    possible to do:

    ```zsh
    zinit run my/plugin ls
    zinit run -l cat \*.plugin.zsh
    zinit run -l pwd
    ```

- 07-11-2019

  - Added a prefix-char: `@` that can be used before plugins if their name collides
    with one of the ice-names. For example `sharkdp/fd` collides with the `sh` ice
    (which causes the plugin to be loaded with the POSIX `sh` emulation applied). To
    load it, do e.g.:

    ```zsh
    zinit as"null" wait"2" lucid from"gh-r" for \
        mv"exa* -> exa" sbin"exa"  ogham/exa \
        mv"fd* -> fd" sbin"fd/fd"  @sharkdp/fd \
        sbin"fzf" junegunn/fzf-bin
    ```

    i.e.: precede the plugin name with `@`. Note: `sbin''` is an ice added by the
    [z-a-bin-gem-node](https://github.com/zinit/z-a-bin-gem-node) annex, it provides
    the command to the command line without altering `$PATH`.

    See the [Zinit Wiki](http://z-shell.org/zinit/wiki/For-Syntax/) for more
    information on the for-syntax.

- 06-11-2019

  - A new syntax, called for-syntax. Example:

    ```zsh
     zinit as"program" atload'print Hi!' for \
         atinit'print First!' z-shell/null \
         atinit'print Second!' svn OMZ::plugins/git
    ```

    The output:

    ```
    First!
    Hi!
    Second!
    Hi!
    ```

    And also:

    ```zsh
    % print -rl $path | egrep -i '(/git|null)'
    /root/.zinit/snippets/OMZ::plugins/git
    /root/.zinit/plugins/z-shell---null
    ```

    To load in light mode, use a new `light-mode` ice. More examples and information
    can be found on the [Zinit Wiki](http://z-shell.org/zinit/wiki/For-Syntax/).

- 03-11-2019

  - A new value for the `as''` ice – `null`. Specifying `as"null"` is like specifying
    `pick"/dev/null" nocompletions`, i.e.: it disables the sourcing of the default
    script file of a plugin or snippet and also disables the installation of
    completions.

- 30-10-2019

  - A new ice `trigger-load''` – create a function that loads given plugin/snippet,
    with an option (to use it, precede the ice content with `!`) to automatically
    forward the call afterwards. Example use:

    ```zsh
    # Invoking the command `crasis' will load the plugin that
    # provides the function `crasis', and it will be then
    # immediately invoked with the same arguments
    zinit ice trigger-load'!crasis'
    zinit load z-shell/zinit-crasis
    ```

- 22-10-2019

  - A new ice `countdown` – causes an interruptable (by Ctrl-C) countdown 5…4…3…2…1…0
    to be displayed before running the `atclone''`, `atpull''` and `make` ices.

- 21-10-2019

  - The `times` command has a new option `-m` – it shows the **moments** of the plugin
    load times – i.e.: how late after loading Zinit a plugin has been loaded.

- 20-10-2019

  - The `zinit` completion now completes also snippets! The command `snippet`, but
    also `delete`, `recall`, `edit`, `cd`, etc. all receive such completing.
  - The `ice` subcommand can now be skipped – just pass in the ices, e.g.:
    ```zsh
    zinit atload"zicompinit; zicdreplay" blockf
    zinit light zsh-users/zsh-completions
    ```
  - The `compile` command is able to compile snippets.
  - The plugins that add their subdirectories into `$fpath` can be now `blockf`-ed –
    the functions located in the dirs will be correctly auto-loaded.

- 12-10-2019

  - Special value for the `id-as''` ice – `auto`. It sets the plugin/snippet ID
    automatically to the last component of its spec, e.g.:

    ```zsh
    zinit ice id-as"auto"
    zinit load robobenklein/zinc
    ```

    will load the plugin as `id-as'zinc'`.

- 14-09-2019

  - There's a Vim plugin which extends syntax highlighting of zsh scripts with coloring
    of the Zinit commands. [Project
    homepage](https://github.com/zinit/zinit-vim-syntax).

- 13-09-2019

  - New ice `aliases` which loads plugin with the aliases mechanism enabled. Use for
    plugins that define **and use** aliases in their scripts.

- 11-09-2019

  - New ice-mods `sh`,`bash`,`ksh`,`csh` that load plugins (and snippets) with the
    **sticky emulation** feature of Zsh – all functions defined within the plugin will
    automatically switch to the desired emulation mode before executing and switch back
    thereafter. In other words it is now possible to load e.g. bash plugins with
    Zinit, provided that the emulation level done by Zsh is sufficient, e.g.:

    ```zsh
    zinit ice bash pick"bash_it.sh" \
            atinit"BASH_IT=${ZINIT[PLUGINS_DIR]}/Bash-it---bash-it" \
            atclone"yes n | ./install.sh"
    zinit load Bash-it/bash-it
    ```

    This script loads correctly thanks to the emulation, however it isn't functional
    because it uses `type -t …` to check if a function exists.

- 10-09-2019

  - A new ice-mod `reset''` that ivokes `git reset --hard` (or the provided command)
    before `git pull` and `atpull''` ice. It can be used it to implement altering (i.e.
    patching) of the plugin's files inside the `atpull''` ice – `git` will report no
    conflicts when doing `pull`, and the changes can be then again introduced by the
    `atpull''` ice..
  - Three new zinit annexes (i.e.
    [extensions](http://z-shell.org/zinit/wiki/Annexes/)):

    - [z-a-man](https://github.com/zinit/z-a-man)

      Generates man pages and code-documentation man pages from plugin's README.md
      and source files (the code documentation is obtained from
      [Zshelldoc](https://github.com/z-shell/zshelldoc)).

    - [z-a-test](https://github.com/zinit/z-a-test)

      Runs tests (if detected `test' target in a `Makefile`or any`\*.zunit` files)
      on plugin installation and non-empty update.

    - [z-a-patch-dl](https://github.com/zinit/z-a-patch-dl)

      Allows easy download and applying of patches, to e.g. aid building a binary
      program equipped in the plugin.

  - A new variable is being recognized by the installation script:
    `$ZINIT_BIN_DIR_NAME`. It configures the directory within `$ZINIT_HOME` to which
    zinit should be cloned.

- 09-08-2019

  - A new ice-mod `wrap-track''` which gets `;`-separated list of functions that are to
    be tracked **once** when executing. In other words you can extend the tracking
    beyond the moment of loading of a plugin.
  - The unloading of Zle widgets is now more smart – it takes into account the chains
    of plugins that can overload the Zle widgets, and solves the interactions that
    result out of it.

- 29-07-2019

  - `delete` now supports following options:
    - `--all` – deletes all plugins and snippets (a purge, similar to `rm -rf ${ZINIT[PLUGINS_DIR]} ${ZINIT[SNIPPETS_DIR]}`)
    - `--clean` – deletes only plugins and snippets that are **currently not loaded**
      in the current session.

- 09-07-2019

  - zinit can now have **its own plugins**, called **z-plugins**! Check out an
    example but fully functional z-plugin
    [z-shell/z-p-submods](https://github.com/z-shell/z-p-submods) and a document that
    explains on how to implement your own z-plugin
    ([here](../../wiki/Z-PLUGINS)).

- 08-07-2019

  - You can now do `zinit ice wait ...` and it will work as `zinit ice wait'0' ...`
    :) I.e. when there's no value to the `wait''` ice then a value of `0` is being
    substituted.

- 02-07-2019

  - [Cooperation of Fast-Syntax-Highlighting and
    zinit](https://asciinema.org/a/254630) – a new precise highlighting for
    zinit in F-Sy-H.

- 01-07-2019

  - `atclone''`, `atpull''` & `make''` get run in the same subshell, thus an e.g.
    export done in `atclone''` will be visible during the `make`.

- 26-06-2019

  - `notify''` contents gets evaluated, i.e. can contain active code like `$(tail -1 /var/log/messages)`, etc.

- 23-06-2019

  - New ice mod `subscribe''`/`on-update-of''` which works like the
    `wait''` ice-mod, i.e. defers loading of a plugin, but it **looks at
    modification time of the given file(s)**, and when it changes, it then
    triggers loading of the plugin/snippet:

    ```zsh
    % zinit ice on-update-of'{~/files-*,/tmp/files-*}' lucid \
        atload"echo I have been loaded" \
        notify"Yes that's true :)"
    % zinit load z-shell/null
    % touch ~/files-1
    The plugin has been loaded
    %
    Yes that's true :)
    ```

    The plugin/snippet will be sourced as many times as the file gets updated.

- 22-06-2019

  - New ice mod `reset-prompt` that will issue `zle .reset-prompt` after loading the
    plugin or snippet, causing the prompt to be recomputed. Useful with themes &
    turbo-mode.

  - New ice-mod `notify''` which will cause to display an under-prompt notification
    when the plugin or snippet gets loaded. E.g.:

    ```zsh
    % zinit ice wait"0" lucid notify"z-shell/null has been loaded"
    % zinit light z-shell/null
    %
    z-shell/null has been loaded
    ```

    In case of problems with the loading a warning message will be output:

    ```
    % zinit ice notify atload'return 7'
    % zinit light z-shell/null
    %
    notify: Plugin not loaded / loaded with problem, the return code: 7
    ```

    Refer to [Ice Modifiers](#ice-modifiers) section for a complete description.

- 29-05-2019

  - Turbo-Mode, i.e. the `wait''` ice-mode now supports a suffix – the letter `a`, `b`
    or `c`. The meaning is illustrated by the following example:

    ```zsh
    zinit ice wait"0b" as"command" pick"wd.sh" atinit"echo Firing 1" lucid
    zinit light mfaerevaag/wd
    zinit ice wait"0a" as"command" pick"wd.sh" atinit"echo Firing 2" lucid
    zinit light mfaerevaag/wd

    # The output
    Firing 2
    Firing 1
    ```

    As it can be seen, the second plugin has been loaded first. That's because there
    are now three sub-slots (the `a`, `b` and `c`) in which the plugin/snippet loadings
    can be put into. Plugins from the same time-slot with suffix `a` will be loaded
    before plugins with suffix `b`, etc.

    In other words, instead of `wait'1'` you can enter `wait'1a'`,
    `wait'1b'` and `wait'1c'` – to this way **impose order** on the loadings
    **regardless of the order of `zinit` commands**.

- 26-05-2019

  - Turbo-Mode now divides the scheduled events (i.e. loadings of plugins or snippets)
    into packs of 5. In other words, after loading each series of 5 plugins or snippets
    the prompt is activated, i.e. it is feed an amount of CPU time. This will help to
    deliver the promise of background loading without interferences visible to the
    user. If you have some two slow-loading plugins and/or snippets, you can put them
    into some separate blocks of 5 events.

- 18-05-2019

  - New ice-mod `nocd` – it prevents changing current directory into the plugin's directory
    before evaluating `atinit''`, `atload''` etc. ice-mods.

- 12-03-2019
  - Finally reorganizing the `README.md`. Went on asciidoc path, the
    side-documents are written in it and the `README.md` will also be
    converted (example page: [Introduction](doc/INTRODUCTION.adoc))
- 12-10-2018

  - New `id-as''` ice-mod. You can nickname a plugin or snippet, to e.g. load it twice, with different `pick''`
    ice-mod, or from Github binary releases and regular Github repository at the same time. More information
    in [blog post](http://z-shell.org/2018-10-12/Nickname-a-plugin-or-snippet).

- 30-08-2018

  - New `as''` ice-mod value: `completion`. Can be used to install completion-only "plugins", even single
    files:

    ```zsh
    zinit ice as"completion" mv"hub* -> _hub"
    zinit snippet https://github.com/github/hub/blob/master/etc/hub.zsh_completion
    ```

  - Uplift of Git-output, it now has an animated progress-bar:

  ![image](https://raw.githubusercontent.com/z-shell/zinit/images/zinit-progress-bar.gif)

- 15-08-2018

  - New `$ZINIT` field `COMPINIT_OPTS` (also see [Customizing Paths](#customizing-paths--other)). You can pass
    `-C` or `-i` there to mute the `insecure directories` messages. Typical use case could be:
    ```zsh
    zinit ice wait"5" atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" lucid
    zinit light z-shell/fast-syntax-highlighting
    ```

- 13-08-2018

  - `self-update` (subcommand used to update zinit) now lists new commits downloaded by the update:
    ![image](https://raw.githubusercontent.com/z-shell/zinit/images/zinit-self-update.png)

  - New subcommand `bindkeys` that lists what bindkeys each plugin has set up.

- 25-07-2018

  - If you encountered a problem with loading Turbo-Mode plugins, it is fixed now. This occurred in versions
    available between `10` and `23` of July. Issue `zinit self-update` if you installed/updated in this period.
  - New bug-fix release `v2.07`.

- 13-07-2018
  - New `multisrc''` ice, it allows to specify multiple files for sourcing and it uses brace expansion syntax, so for example you can:
    ```zsh
    zinit ice depth"1" multisrc="lib/{functions,misc}.zsh" pick"/dev/null"; zinit load robbyrussell/oh-my-zsh
    zinit ice svn multisrc"{functions,misc}.zsh" pick"/dev/null"; zinit snippet OMZ::lib
    array=( {functions,misc}.zsh ); zinit ice svn multisrc"\${array[@]}" pick"/dev/null"; zinit snippet OMZ::lib
    array=( {functions,misc}.zsh ); zinit ice svn multisrc"${array[@]}" pick"/dev/null"; zinit snippet OMZ::lib
    array=( {functions,misc}.zsh ); zinit ice svn multisrc"\$array" pick"/dev/null"; zinit snippet OMZ::lib
    array=( {functions,misc}.zsh ); zinit ice svn multisrc"$array" pick"/dev/null"; zinit snippet OMZ::lib
    zinit ice svn multisrc"misc.zsh functions.zsh" pick"/dev/null"; zinit snippet OMZ::lib
    ```
- 12-07-2018

  - For docker and new machine provisioning, there's a trick that allows to install all [turbo-mode](#turbo-mode-zsh--53)
    plugins by scripting:

    ```zsh
    zsh -i -c -- '-zinit-scheduler burst'
    ```

- 10-07-2018

  - Ice `wait'0'` now means actually short time – you can load plugins and snippets **very quickly** after prompt.

- 02-03-2018

  - zinit exports `$ZPFX` parameter. Its default value is `~/.zinit/polaris` (user can
    override it before sourcing zinit). This directory is like `/usr/local`, a prefix
    for installed software, so it's possible to use ice like `make"PREFIX=$ZPFX"` or
    `atclone"./configure --prefix=$ZPFX"`. zinit also setups `$MANPATH` pointing to the
    `polaris` directory. Checkout [gallery](GALLERY.md) for examples.
  - [New README section](#hint-extending-git) about extending Git with zinit.

- 05-02-2018

  - I work much on this README however multi-file Wiki might be better to read – it
    [just has been created](https://github.com/z-shell/zinit/wiki).

- 16-01-2018

  - New ice-mod `compile` which takes pattern to select additional files to compile, e.g.
    `zinit ice compile"(hsmw-*|history-*)"` (for `z-shell/history-search-multi-word` plugin).
    See [Ice Modifiers](#ice-modifiers).

- 14-01-2018

  - Two functions have been exposed: `zpcdreplay` and `zpcompinit`. First one invokes compdef-replay,
    second one is equal to `autoload compinit; compinit` (it also respects `$ZINIT[ZCOMPDUMP_PATH]`).
    You can use e.g. `atinit'zpcompinit'` ice-mod in a syntax-highlighting plugin, to initialize
    completion right-before setting up syntax highlighting (because that should be done at the end).

- 13-01-2018

  - New customizable path `$ZINIT[ZCOMPDUMP_PATH]` that allows to point zinit to non-standard
    `.zcompdump` location.
  - Tilde-expansion is now performed on the [customizable paths](#customizing-paths--other) – you can
    assign paths like `~/.zinit`, there's no need to use `$HOME/.zinit`.

- 31-12-2017

  - For the new year there's a new feature: user-services spawned by Zshell :) Check out
    [available services](https://github.com/zservices). They are configured like their
    READMEs say, and controlled via:

    ```
    % zinit srv redis next    # current serving shell will drop the service, next Zshell will pick it up
    % zinit srv redis quit    # the serving shell will quit managing the service, next Zshell will pick it up
    % zinit srv redis stop    # stop serving, do not pass it to any shell, just hold the service
    % zinit srv redis start   # start stopped service, without changing the serving shell
    % zinit srv redis restart # restart service, without changing the serving shell
    ```

    This feature allows to configure everything in `.zshrc`, without the the need to deal with `systemd` or
    `launchd`, and can be useful e.g. to configure shared-variables (across Zshells), stored in `redis` database
    (details on [zservices/redis](https://github.com/zservices/redis)).

- 24-12-2017

  - Xmas present – [fast-syntax-highlighting](https://github.com/z-shell/fast-syntax-highlighting)
    now highlights the quoted part in `atinit"echo Initializing"`, i.e. it supports ICE syntax :)

- 08-12-2017

  - SVN snippets are compiled on install and update
  - Resolved how should ice-mods be remembered – general rule is that using `zinit ice ...` makes
    memory-saved and disk-saved ice-mods not used, and replaced on update. Calling e.g. `zinit update ...` without preceding `ice` uses memory, then disk-saved ices.

- 07-12-2017

  - New subcommand `delete` that obtains plugin-spec or URL and deletes plugin or snippet from disk.
    It's good to forget wrongly passed Ice-mods (which are storred on disk e.g. for `update --all`).

- 04-12-2017

  - It's possible to set plugin loading and unloading on condition. zinit supports plugin unloading,
    so it's possible to e.g. **unload prompt and load another one**, on e.g. directory change. Checkout
    [full story](#automatic-loadunload-on-condition) and [Asciinema video](https://asciinema.org/a/150825).

- 29-11-2017

  - **[Turbo Mode](https://github.com/z-shell/zinit#turbo-mode-zsh--53)** – **39-50% or more faster Zsh startup!**
  - Subcommand `update` can update snippets, via given URL (up to this point snippets were updated via
    `zinit update --all`).
  - Completion management is enabled for snippets (not only plugins).

- 13-11-2017

  - New ice modifier – `make`. It causes the `make`-command to be executed after cloning or updating
    plugins and snippets. For example there's `Zshelldoc` that uses `Makefile` to build final scripts:

    ```SystemVerilog
    zinit ice as"program" pick"build/zsd*" make; zinit light z-shell/zshelldoc
    ```

    The above doesn't trigger the `install` target, but this does:

    ```SystemVerilog
    zinit ice as"program" pick"build/zsd*" make"install PREFIX=/tmp"; zinit light z-shell/zshelldoc
    ```

  - Fixed problem with binary-release selection (`from"gh-r"`) by adding Ice-mod `bpick`, which
    should be used for this purpose instead of `pick`, which selects file within plugin tree.

- 06-11-2017

  - The subcommand `clist` now prints `3` completions per line (not `1`). This makes large amount
    of completions to look better. Argument can be given, e.g. `6`, to increase the grouping.
  - New Ice-mod `silent` that mutes `stderr` & `stdout` of a plugin or snippet.

- 04-11-2017

  - New subcommand `ls` which lists snippets-directory in a formatted and colorized manner. Example:

  ![zinit-ls](https://raw.githubusercontent.com/z-shell/zinit/images/zinit-ls.png)

- 29-10-2017

  - Subversion protocol (supported by Github) can be used to clone **subdirectories** when using
    snippets. This allows to load multi-file snippets. For example:

    ```SystemVerilog
    zstyle ':prezto:module:prompt' theme smiley
    zinit ice svn silent; zinit snippet PZT::modules/prompt
    ```

  - Snippets support `Prezto` modules (with dependencies), and can use **PZT::** URL-shorthand,
    like in the example above. One can load `Prezto` module as single file snippet, or use Subversion
    to download whole directory (see also description of [Ice Modifiers](#ice-modifiers)):

    ```zsh
    # Single file snippet, URL points to file

    zinit snippet PZT::modules/helper/init.zsh

    # Multi-file snippet, URL points to directory to clone with Subversion
    # The file to source (init.zsh) is automatically detected

    zinit ice svn; zinit snippet PZT::modules/prompt

    # Use of Subversion to load an OMZ plugin

    zinit ice svn; zinit snippet OMZ::plugins/git
    ```

  - Fixed a bug with `cURL` usage (snippets) for downloading, it will now be properly used

- 13-10-2017

  - Snippets can use "**OMZ::**" prefix to easily point to `Oh-My-Zsh` plugins and libraries, e.g.:

    ```SystemVerilog
    zinit snippet OMZ::lib/git.zsh
    zinit snippet OMZ::plugins/git/git.plugin.zsh
    ```

- 12-10-2017

  - The `cd` subcommand can now obtain URL and move session to **snippet** directory
  - The `times` subcommand now includes statistics on snippets. Also, entries
    are displayed in order of loading:

    ```zsh
    % zinit times
    Plugin loading times:
    0.010 sec - OMZ::lib/git.zsh
    0.001 sec - OMZ::plugins/git/git.plugin.zsh
    0.003 sec - z-shell/history-search-multi-word
    0.003 sec - rimraf/k
    0.003 sec - zsh-users/zsh-autosuggestions
    ```

- 24-09-2017

  - **[Code documentation](zsdoc)** for contributors and interested people.

- 13-06-2017

  - Plugins can now be absolute paths:

    ```SystemVerilog
    zinit load %HOME/github/{directory}
    zinit load /Users/sgniazdowski/github/{directory}
    zinit load %/Users/sgniazdowski/github/{directory}
    ```

    Completions are not automatically installed, but user can run `zinit creinstall %HOME/github/{directory}`, etc.

- 23-05-2017

  - New `ice` modifier: `if`, to which you can provide a conditional expression:

    ```SystemVerilog
    % zinit ice if"(( 0 ))"
    % zinit snippet --command https://github.com/b4b4r07/httpstat/blob/master/httpstat.sh
    % zinit ice if"(( 1 ))"
    % zinit snippet --command https://github.com/b4b4r07/httpstat/blob/master/httpstat.sh
    Setting up snippet httpstat.sh
    Downloading httpstat.sh...
    ```

# !!! This file modified by automated tool by Z-Shell. This tool fix variables and URL for Zinit project.

# For any queries please visit https://github.com/z-shell/zinit/issues
