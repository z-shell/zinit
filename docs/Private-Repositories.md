<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Loading Plugins From Private Repositories And Not Only](#loading-plugins-from-private-repositories-and-not-only)
  - [Introduction](#introduction)
  - [Explanation](#explanation)
  - [Summary](#summary)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Loading Plugins From Private Repositories And Not Only

## Introduction

In order to install and load a plugin whose repository is private - i.e.:
requires providing credentials in order to log in – use the `from''` ice in the
following way:

```zsh
zinit ice from"psprint@github.com"
zinit load psprint/fsh-auto-themes
```

## Explanation

The point is that when the `from''` ice isn't one of `gh`, `github`, `gl`,
`gitlab`, `bb`, `bitbucket`, `nb`, `notabug`, `gh-r`, `github-rel` then **it is
treaten as a domain name** and inserted into the domain position into the clone
url. I.e.: the following (more or less) `git clone` command is being run:

```zsh
git clone https://{from-ice-contents}/user/plugin
```

In order to change the protocol, use the `proto''` ice.

## Summary

By using this method you can clone plugins from e.g. GitHub Enterprise or embed
the passwords as plain text in `.zshrc`.

[]( vim:set ft=markdown tw=80 fo+=a2n autoindent: )
