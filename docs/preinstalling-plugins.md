# Pre-installing Plugins

If you create a Docker image that uses Zinit, or want to install Turbo-loaded
plugins before the shell starts interactively, you can invoke the
zplugin-scheduler function in such a way, that it:

- installs plugins without waiting for the prompt (i.e. it's script friendly),
- installs **all** plugins instantly, without respecting the `wait''` argument.

To accomplish this, use `burst` argument and call `-zplg-scheduler` function.
Example `Dockerfile` entry:

``` zsh
RUN zsh -i -c -- '-zplg-scheduler burst || true'
```

An example `Dockerfile` can be found
[**here**](https://github.com/robobenklein/configs/blob/master/Dockerfile).

[]( vim:set ft=markdown tw=80: )
