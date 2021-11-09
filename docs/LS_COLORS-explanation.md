A repository [**trapd00r/LS_COLORS**](https://github.com/trapd00r/LS_COLORS)
provides a file with color definitions for GNU `ls` command (and also for
[**ogham/exa**](https://github.com/ogham/exa); it can be also used to style Zsh
completion – more on this below). Typically one does `eval $( dircolors -b $HOME/LS_COLORS)` to process this file and set environment for `ls`. However
this means `dircolors` is ran every shell startup.

This costs much time, because a fork has to be done and the program (i.e.
`dircolors`) binary needs to be loaded and executed, and because `dircolors`
loads the colors' definitions and processes them. Following Zinit invocation
solves this problem:

```zsh
zinit ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
  atpull'%atclone' pick"clrs.zsh" nocompile'!' \
  atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit light trapd00r/LS_COLORS
```

- `atclone"…"` – generate shell script, but instead of passing it to `eval`,
  save it to file,
- `atpull'%atclone'` – do the same at any update of plugin (the `atclone` is
  being ran on the _installation_ while the `atpull` hook is being ran on an
  _update_ of the
  [**trapd00r/LS_COLORS**](https://github.com/trapd00r/LS_COLORS) plugin); the
  `%atclone` is just a special string that denotes that the `atclone''` hook
  should be copied onto the `atpull''` hook,
- `pick"clrs.zsh"` – source file `clrs.zsh`, the one that is generated,
- `nocompile'!'` – invokes compilation **after** the `atclone''` ice-mod (the
  exclamation mark causes this).
- `atload"…"` – additionally sets up the Zsh completion to use the colors
  provided by the trapd00r package.

This way, except for the plugin installation and update, `dircolors` isn't ran,
just normal sourcing is done. The every-day sourced file (i.e. `clrs.zsh`) is even
being compiled to speed up the loading.

[]( vim:set ft=markdown tw=80: )
