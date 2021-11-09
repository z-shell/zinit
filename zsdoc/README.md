<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Code documentation](#code-documentation)
- [PDFs, man pages, etc.](#pdfs-man-pages-etc)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Code documentation

Here is `Asciidoc` code documentation generated using [Zshelldoc](https://github.com/z-shell/zshelldoc).
There are `4` Zinit's source files, the main one is [zinit.zsh](zinit.zsh.adoc). The documentation
lists all functions, interactions between them, their comments and features used.

Github allows to directly view `Asciidoc` documents:
 * [zinit.zsh](zinit.zsh.adoc) – always loaded, in `.zshrc` ([pdf](https://z-shell.github.io/zinit/wiki/zinit.zsh))
 * [zinit-side.zsh](zinit-side.zsh.adoc) – common functions, loaded by `*-install` and `*-autoload` scripts ([pdf](https://z-shell.github.io/zinit/wiki/zinit-side.zsh))
 * [zinit-install.zsh](zinit-install.zsh.adoc) – functions used only when installing a plugin or snippet ([pdf](https://z-shell.github.io/zinit/wiki/zinit-install.zsh))
 * [zinit-autoload.zsh](zinit-autoload.zsh.adoc) – functions used only in interactive `Zinit` invocations ([pdf](https://z-shell.github.io/zinit/wiki/zinit-autoload.zsh/))

# PDFs, man pages, etc.

Formats other than `Asciidoc` can be produced by using provided Makefile. For example, issuing
`make pdf` will create and populate a new directory `pdf` (requires `asciidoctor`, install with
`gem install asciidoctor-pdf --pre`). `make man` will create man pages (requires package `asciidoc`,
uses its command `a2x`, which is quite slow).
