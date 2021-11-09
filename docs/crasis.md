# Crasis – semigraphical interface to Zinit

Zsh exposes its parser via `(z)` substitution flag. Parsing `.zshrc` is totally
possible. This way `Crasis` lets you edit your `Zinit` commands located in
`.zshrc`. All in pure `Zshell` code.

No more commenting-out a line with a text editor to disable plugin, cluttering
`.zshrc`, now you can just **press a button**.

[![asciicast](https://asciinema.org/a/147225.png)](https://asciinema.org/a/147225)

`Crasis` uses pure-Zshell [**ZUI**](http://github.com/z-shell/zui/) library to
create `ncurses` interface.

## Installation & Basic Use

Install [**Zinit**](https://github.com/z-shell/zinit) and add following
commands to `.zshrc`:

```SystemVerilog
zinit light z-shell/zui
zinit light z-shell/zinit-crasis
```

To use, invoke `crasis [optional zshrc path]` or press `Ctrl-o-k`. Global
variables `CRASIS_THEME` and `CRASIS_LAYOUT` can be used to override
configuration file `crasis.conf` (located in plugin's tree), i.e.:

```SystemVerilog
CRASIS_THEME="zdharma-256" CRASIS_LAYOUT="contract" crasis
```

`256`-color themes require Zsh `5.3` or later.

## Key Bindings

| Key(s)             | Description                                                      |
| ------------------ | ---------------------------------------------------------------- |
| `<`,`>` or `{`,`}` | Horizontal scroll (i.e. left or right)                           |
| `Ctrl-L`           | Redraw of whole display                                          |
| `Ctrl-U`           | Half page up                                                     |
| `Ctrl-D`           | Half page down                                                   |
| `Ctrl-P`           | Previous line, centered                                          |
| `Ctrl-N`           | Next line, centered                                              |
| `[`, `]`           | Jump to next and previous section (e.g. next plugin or snippet)  |
| `g`, `G`           | Jump to beginning and end of whole interface                     |
| `/`                | Show incremental search                                          |
| `F1`               | Jump to result (in incremental search) and back                  |
| `Esc`              | Exit incremental search, clearing query                          |
| `Ctrl-W`           | Delete whole word (in incremental search)                        |
| `Ctrl-K`           | Delete whole line (in incremental search)                        |
| Up and down        | Resize text field when editing it (e.g. to make the text fit in) |

## Screenshots

![clean-256](https://raw.githubusercontent.com/z-shell/zinit-crasis/main/themes/screenshots/clean-256.png)

![zdharma-256](https://raw.githubusercontent.com/z-shell/zinit-crasis/main/themes/screenshots/zdharma-256.png)

## Code Documentation

`Crasis` is a [**ZUI**](http://github.com/z-shell/zui/) application. `ZUI` is a
pure-Zshell library where user generates simple text with hyperlinks, which is
then turned into active document with buttons. Check out `Crasis` code
documentation:
[**Asciidoc**](https://github.com/z-shell/zinit-crasis/blob/main/zsdoc/crasis.adoc),
[**PDF**](http://z-shell.github.io/zinit-crasis/crasis.pdf).

[]( vim:set ft=markdown tw=80: )
