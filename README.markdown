Dotfiles (Tom Ryder)
====================

Personal repository of dotfiles. This is for those settings that migrate well
from machine to machine and that I consider safe to publish. You’re welcome to
use them, and there’s an attempt to keep my own personal data out of the files,
but you’ll probably want to fork it to remove anything peculiar to my setup
that I’ve left in here.

It’s more likely you’ll want to read the configuration files and find snippets
relevant to your particular workflow.

Tools
-----

Configuration is included for:

*   [Bash](https://www.gnu.org/software/bash/) — GNU Bourne-Again Shell,
    including a `~/.profile` configured to work with most Bourne-compatible
    shells
*   [cURL](http://curl.haxx.se/) — Command-line tool for transferring data with
    URL syntax
*   [`dircolors(1)`](https://www.gnu.org/software/coreutils/manual/html_node/dircolors-invocation.html)
    — Color GNU `ls(1)` output
*   [Git](http://git-scm.com/) — Distributed version control system
*   [GnuPG](http://www.gnupg.org/) — GNU Privacy Guard, for private
    communication and file encryption
*   [i3](http://i3wm.org/) — Tiling window manager
*   [Mutt](http://www.mutt.org/) — Terminal mail user agent
*   [`mysql(1)`](http://linux.die.net/man/1/mysql) — Command-line MySQL client
*   [Ncmpcpp](http://ncmpcpp.rybczak.net/) — ncurses music player client
*   [Newsbeuter](http://www.newsbeuter.org/) — Terminal RSS/Atom feed reader
*   [`psql(1)`](http://linux.die.net/man/1/psql) — Command-line PostgreSQL
    client
*   [Readline](http://cnswww.cns.cwru.edu/php/chet/readline/rltop.html) — GNU
    library for user input used by Bash, MySQL, and others
*   [Taskwarrior](http://taskwarrior.org/projects/show/taskwarrior) —
    Command-line task list manager
*   [tmux](http://tmux.sourceforge.net/) — Terminal multiplexer similar to GNU
    Screen
*   [rxvt-unicode](http://software.schmorp.de/pkg/rxvt-unicode.html) — Fork of
    the rxvt terminal emulator with Unicode support
*   [Vim](http://www.vim.org/) — Vi IMproved, a text editor
*   [Vimperator](http://www.vimperator.org/vimperator) — Vimperator, a Firefox
    browser extension allowing Vim-like modes and keybindings
*   [Wyrd](http://pessimization.com/software/wyrd/) — a `curses` calendar
    frontend for [Remind](http://www.roaringpenguin.com/products/remind)
*   [X11](http://www.x.org/wiki/) — Windowing system with network transparency
    for Unix

Also included are a few scripts for `~/.local/bin`, and their `man(1)` pages.

The configurations for Bash, GnuPG, Mutt, tmux, and Vim are the most expansive
and most likely to be of interest. The i3 configuration is mostly changed to
make window switching behave like Vim windows and tmux panes do, and there’s a
fair few resources defined for rxvt-unicode. Otherwise, the rest of the
configuration isn’t too distant from the defaults.

Installation
------------

```bash
$ git clone git://github.com/tejr/dotfiles.git ~/.dotfiles
$ cd ~/.dotfiles
$ git submodule init
$ make
$ make -n install
$ make install
```

For the default target, you’ll need `bash(1)`, `git(1)`, `install(1)`,
`make(1)`, `m4(1)`, and `tic(1)`. You’ll need to have a recent enough version
of Git to support [submodules](http://git-scm.com/book/en/Git-Tools-Submodules)
for the Vim installation to work; it’s required for the plugin setup.

The installation `Makefile` will overwrite things standing in the way of its
installed files without backing them up, so read the output of `make -n
install` before running `make install` to make sure you aren’t going to lose
anything unexpected. If you’re still not sure, install it in a temporary
directory so you can explore:

    $ mktemp -d
    /tmp/tmp.YZFW8ScFZP
    $ make install HOME=/tmp/tmp.YZFW8ScFZP

The default target will install the core terminal-only files (cURL, Git, GnuPG,
Vim, and shell and terminal setup files). The remaining dotfiles can be
installed with the other targets. Take a look at the `Makefile` to see what’s
available.

Shell
-----

My `.profile` and other files in `sh` are written in Bourne/POSIX shell script
so that they can be parsed by any Bourne-compatible shell, including `zsh`,
`dash`, and \*BSD implementations of `sh`. Individual scripts called by
`.profile` are saved in `.profile.d` and iterated on login for ease of
management. All of these boil down to exporting variables appropriate to the
system and the software it has available.

My `.bash_profile` calls `.profile` for variable exports, and then runs
`.bashrc` for interactive shells. Subscripts are kept in `.bashrc.d`, and all
are loaded for the creation of any new interactive shell. The contents of this
directory changes all the time depending on the host, and only specific scripts
in it are versioned.

My interactive and scripting shell of choice is Bash; as a GNU/Linux admin who
ends up installing Bash on \*BSD machines anyway, I very rarely have to write
Bourne-compatible scripts, so all of these files are replete with Bashisms.

As I occasionally have work on very old internal systems, my Bash is written to
work with [any version 2.05a or
newer](http://wiki.bash-hackers.org/scripting/bashchanges), a few versions
after the less error-prone `[[` test syntax was introduced. This is why I use
older syntax for certain things such as appending items to arrays:

```bash
array=("${array[@]}" "$item")
```

Compare this to the much nicer syntax available since 3.1-alpha1, which
actually works for arrays with sparse indexes, unlike the above syntax:

```bash
array+=("$item")
```

Where I do use features that are only available in versions of Bash newer than
2.05a, such as newer `shopt` options or `PROMPT_DIRTRIM`, they are only run
after testing `BASH_VERSINFO` appropriately.

When I use any other Bourne-compatible shell, I’m generally happy to accept its
defaults for interactive behavior.

My prompt looks something like this:

![Bash prompt](prompt.png)

It expands based on context to include these elements in this order:

*   Whether in a Git, Mercurial, or Subversion repository if applicable, and
    punctuation to show whether there are local modifications at a glance
*   The number of running background jobs, if non-zero
*   The exit status of the last command, if non-zero

This is all managed within the `prompt` function. There’s some mildly hacky
logic on `tput` codes included such that it should work correctly for most
common terminals using both `termcap(5)` and `terminfo(5)`, including \*BSD
systems. It’s also designed to degrade gracefully for eight-color and no-color
terminals.

### Completion

I find the `bash-completion` package a bit too heavy for my tastes, and turn it
off using a stub file installed in `.config/bash_completion`. The majority of
the time I just want to complete paths anyway, and this makes for a quicker
startup without a lot of junk functions in my Bash namespace.

I do make some exceptions with completions defined in `.bashrc.d` files for
things I really do get tired of typing repeatedly:

*   Builtins, commands, help topics, shell options, and variables
*   `ftp(1)` hostnames from `~/.netrc`
*   `git(1)` branch names
*   `gpg(1)` long options
*   `make(1)` targets read from a `Makefile`
*   `mysql(1)` databases from `~/.mysql/*.cnf`
*   `pass(1)` entries
*   `ssh(1)` hostnames from `~/.ssh/config`

### Functions

There are a few other little tricks in `bash/bashrc.d`, including:

*   `bd` — Change into a named ancestor of the current directory
*   `ca` — Count given arguments
*   `cf` — Count files in a given directory
*   `hgrep` — `HISTFILE` search
*   `mkcd` — Create a directory and change into it
*   `mkcp` — Create a directory and copy arguments into it
*   `mkmv` — Create a directory and move arguments into it
*   `pa` — Print given arguments, one per line
*   `pd` — Change to the argument’s parent directory
*   `scr` — Create a temporary directory and change into it
*   `sprunge` — Pastebin frontend tool I pilfered from `#bash` on Freenode

I also wrap a few command calls with functions to stop me from doing silly
things that the commands themselves don’t catch. My favourite is the one that
stops me from calling `scp(1)` with no colon in either argument. I also do
things like give default arguments to `remind(1)` and `pwgen(1)`.

### Testing

You can test that both sets of shell scripts are syntactically correct with
`make test-bash`, `make test-sh`, or `make test` for everything including the
scripts in `bin`.

GnuPG
-----

The configuration for GnuPG is intended to follow [RiseUp’s OpenPGP best
practices](https://help.riseup.net/en/security/message-security/openpgp/best-practices).
The configuration file is rebuilt using `m4(1)` and `make(1)` because it
requires hard-coding a path to the SKS keyserver certificate authority, and
neither tilde nor `$HOME` expansion works for this.

Mutt
----

My mail is kept in individual Maildirs under `~/Mail`, with `inbox` being where
most unfiltered mail is sent. I use
[Getmail](http://pyropus.ca/software/getmail/),
[Procmail](http://www.procmail.org/), and
[MSMTP](http://msmtp.sourceforge.net/); the configurations for these are not
included here. I make heavy use of GnuPG for email—everything is signed by
default, and I encrypt whenever I have a public key available for the
recipient. The GnuPG interfacing is done with
[GPGme](http://www.gnupg.org/related_software/gpgme/), rather than defining
commands for each crypto operation. I wrote [an article about this
setup](http://blog.sanctum.geek.nz/linux-crypto-email/) if it sounds appealing.

You’ll need [Abook](http://abook.sourceforge.net/) installed if you want to use
the `query_command` I have defined, and [msmtp](http://msmtp.sourceforge.net/)
for the `sendmail` command.

rxvt-unicode
------------

A tiny script called `clip` is included in `~/.urxvt/ext` to copy selections
into the X `CLIPBOARD` buffer as well as `PRIMARY`. This is purely preference
as I find it pretty maddening otherwise, particularly when dealing with URLs
from IRC.

The included `.Xresources` file assumes that `urxvt` can use 256 colors and
Perl extensions, and has its standard `selection` script available. If you’re
missing functionality, try changing `perl-ext-common` to `default`.

My choice of font is [Ubuntu Mono](http://font.ubuntu.com/), but the file
should allow falling back to the more common [Deja Vu Sans
Mono](http://dejavu-fonts.org/wiki/Main_Page). I’ve found
[Terminus](http://terminus-font.sourceforge.net/) works well too, but bitmap
fonts are not really my cup of tea. The Lohit Kannada font bit is purely to
make ಠ\_ಠ work correctly. ( ͡° ͜ʖ ͡°) seems to work out of the box.

tmux
----

These are just generally vi-friendly settings, not much out of the ordinary.
Note that the configuration presently uses a hard-coded 256-color colorscheme,
and uses non-login shells, with an attempt to control the environment to stop
shells thinking they have access to an X display—I’m forced to use PuTTY a lot
at work, and I don’t like Xming very much.

The configuration for Bash includes a `tmux` function designed to make `attach`
into the default command if no arguments are given and sessions do already
exist. The default command is normally `new-session`.

Vim
---

The majority of the `.vimrc` file is just setting options, with a few mappings.
I try not to deviate too much from the Vim defaults behaviour in terms of
interactive behavior and keybindings.

The configuration is extensively commented, mostly because I was reading
through it one day and realised I’d forgotten what half of it did. Plugins are
loaded using @tpope’s [pathogen.vim](https://github.com/tpope/vim-pathogen).

Scripts
-------

Three SSH-related scripts and their manuals are included:

*   `shoal(1)` — Print hostnames read from a `ssh_config(5)` file
*   `scatter(1)` — Run command on multiple hosts read from `shoal(1)` and print
    output
*   `shock(1)` — Run command on multiple hosts read from `shoal(1)` and print
    the hostname if the command returns zero

If you want to use the manuals, you may need to add `~/.local/share/man` to
your `/etc/manpath` configuration, depending on your system.

There's also a script `han(1)` to provide a `keywordprg` for Bash script
development that will look for `help` topics. You could use it from the shell
too. It also has a brief manual.

Known issues
------------

I’d welcome patches or advice on fixing any of these problems.

*   The `install-terminfo` target does not work correctly on NetBSD due to the
    different way `tic(1)` works, which I don’t understand at all.

License
-------

Public domain; see the included `UNLICENSE` file. It’s just configuration, do
whatever you like with it if any of it’s useful to you. If you’re feeling
generous, you could always [buy me a beer](https://sanctum.geek.nz/) next time
you’re in New Zealand.

