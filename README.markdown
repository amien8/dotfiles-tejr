Dotfiles (Tom Ryder)
====================

This is my personal repository of [dotfiles](https://dotfiles.github.io/),
including most of the settings that migrate well between machines. You can fork
and use this directly, but it’s more likely you’ll want to read the files and
find snippets relevant to your workflow.

Installation
------------

    $ git clone git://github.com/tejr/dotfiles.git ~/.dotfiles
    $ cd ~/.dotfiles
    $ git submodule init
    $ make
    $ make -n install
    $ make install

For the default target, you’ll need `bash(1)`, `git(1)`, `install(1)`,
`make(1)`, `m4(1)`, and `tic(1)`. You’ll need to have a recent enough version
of Git to support [submodules](http://git-scm.com/book/en/Git-Tools-Submodules)
for the Vim installation to work; it’s required for the plugin setup.

The installation `Makefile` will overwrite things standing in the way of its
installed files without backing them up, so read the output of `make -n
install` before running `make install` to make sure you aren’t going to lose
anything unexpected. If you’re still not sure, install it in a temporary
directory so you can explore:

    $ tmpdir=$(mktemp -d)
    $ make install HOME="$tmpdir"
    $ env -i HOME="$tmpdir" TERM="$TERM" bash -l

The default target will install the core terminal-only files (cURL, Git, GnuPG,
Vim, and shell and terminal setup files). The remaining dotfiles can be
installed with the other targets. Take a look at the `Makefile` to see what’s
available.

Tools
-----

Configuration is included for:

*   [Abook](http://abook.sourceforge.net/) — curses address book program
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
*   [GTK+](http://www.gtk.org/) — GIMP Toolkit, for graphical user interface
    elements
*   [i3](http://i3wm.org/) — Tiling window manager
*   [Mutt](http://www.mutt.org/) — Terminal mail user agent
*   [`mysql(1)`](http://linux.die.net/man/1/mysql) — Command-line MySQL client
*   [Ncmpcpp](http://ncmpcpp.rybczak.net/) — ncurses music player client
*   [Newsbeuter](http://www.newsbeuter.org/) — Terminal RSS/Atom feed reader
*   [`psql(1)`](http://linux.die.net/man/1/psql) — Command-line PostgreSQL
    client
*   [Perl::Critic](http://perlcritic.com/) — static source code analysis engine
    for Perl
*   [Readline](http://cnswww.cns.cwru.edu/php/chet/readline/rltop.html) — GNU
    library for user input used by Bash, MySQL, and others
*   [Taskwarrior](http://taskwarrior.org/projects/show/taskwarrior) —
    Command-line task list manager
*   [tmux](http://tmux.sourceforge.net/) — Terminal multiplexer similar to GNU
    Screen
*   [rxvt-unicode](http://software.schmorp.de/pkg/rxvt-unicode.html) — Fork of
    the rxvt terminal emulator with Unicode support
*   [Subversion](https://subversion.apache.org/) — Apache Subversion, a version
    control system
*   [Vim](http://www.vim.org/) — Vi IMproved, a text editor
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

### Shell

My `.profile` and other files in `sh` are written in Bourne/POSIX shell script,
so they should work in most `sh(1)` implementations. Individual scripts called
by `.profile` are saved in `.profile.d` and iterated on login for ease of
management. All of these boil down to exporting variables appropriate to the
system and the software it has available.

My `.bash_profile` calls `.profile` and then runs subscripts in
`.bash_profile.d`. It then runs `.bashrc`, which only applies for interactive
shells; subscripts for that in turn are loaded from `.bashrc.d`. The contents
of the two directories changes depending on the host, so only specific scripts
in it are versioned.

My interactive and scripting shell of choice is Bash; as a GNU/Linux admin who
ends up installing Bash on \*BSD machines anyway, I very rarely have to write
Bourne-compatible scripts, so all of these files are replete with Bashisms.

As I occasionally have work on very old internal systems, my Bash is written to
work with [any version 2.05a or
newer](http://wiki.bash-hackers.org/scripting/bashchanges). This is why I use
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

You can set `PROMPT_PREFIX` and/or `PROMPT_SUFFIX` too, which do about what
you’d expect.

This is all managed within the `prompt` function. There’s some mildly hacky
logic on `tput` codes included such that it should work correctly for most
common terminals using both `termcap(5)` and `terminfo(5)`, including \*BSD
systems. It’s also designed to degrade gracefully for eight-color and no-color
terminals.

#### Completion

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

#### Functions

There are a few other little tricks in `bash/bashrc.d`, including:

*   `apf` — Prepend arguments to a command with ones read from a file
*   `bd` — Change into a named ancestor of the current directory
*   `ca` — Count given arguments
*   `cf` — Count files in a given directory
*   `fnl` — Run a command and save its output and error into temporary files
*   `hgrep` — `HISTFILE` search
*   `mkcd` — Create a directory and change into it
*   `mkcp` — Create a directory and copy arguments into it
*   `mkmv` — Create a directory and move arguments into it
*   `pa` — Print given arguments, one per line
*   `path` — Manage the contents of `PATH` conveniently
*   `paz` — Print given arguments separated by NULL chars
*   `pd` — Change to the argument’s parent directory
*   `readz` — Alias for `read -d '' -r`
*   `scr` — Create a temporary directory and change into it
*   `sd` — Switch to a sibling directory
*   `sprunge` — Pastebin frontend tool I pilfered from `#bash` on Freenode
*   `ud` — Change into an indexed ancestor of a directory

I also wrap a few command calls with functions to stop me from doing silly
things that the commands themselves don’t catch. My favourite is the one that
stops me from calling `scp(1)` with no colon in either argument. I also do
things like give default arguments to `pwgen(1)`.

### GnuPG

The configuration for GnuPG is intended to follow [RiseUp’s OpenPGP best
practices](https://help.riseup.net/en/security/message-security/openpgp/best-practices).
The configuration file is rebuilt using `m4(1)` and `make(1)` because it
requires hard-coding a path to the SKS keyserver certificate authority, and
neither tilde nor `$HOME` expansion works for this.

### Mutt

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

### rxvt-unicode

A tiny script called `clip` is included in `~/.urxvt/ext` to copy selections
into the X `CLIPBOARD` buffer as well as `PRIMARY`. This is purely preference
as I find it pretty maddening otherwise, particularly when dealing with URLs
from IRC.

The included `.Xresources` file assumes that `urxvt` can use 256 colors and
Perl extensions. If you’re missing functionality, try changing
`perl-ext-common` to `default`.

My choice of font is [Ubuntu Mono](http://font.ubuntu.com/), but the file
should allow falling back to the more common [Deja Vu Sans
Mono](http://dejavu-fonts.org/wiki/Main_Page). I’ve found
[Terminus](http://terminus-font.sourceforge.net/) works well too, but bitmap
fonts are not really my cup of tea. The Lohit Kannada font bit is purely to
make ಠ\_ಠ work correctly. ( ͡° ͜ʖ ͡°) seems to work out of the box.

### tmux

These are just generally vi-friendly settings, not much out of the ordinary.
Note that the configuration presently uses a hard-coded 256-color colorscheme,
and uses non-login shells, with an attempt to control the environment to stop
shells thinking they have access to an X display—I’m forced to use PuTTY a lot
at work, and I don’t like Xming very much.

The configuration for Bash includes a `tmux` function designed to make `attach`
into the default command if no arguments are given and sessions do already
exist. The default command is normally `new-session`.

### Vim

The majority of the `.vimrc` file is just setting options, with a few mappings.
I try not to deviate too much from the Vim defaults behaviour in terms of
interactive behavior and keybindings.

The configuration is extensively commented, mostly because I was reading
through it one day and realised I’d forgotten what half of it did. Plugins are
loaded using @tpope’s [pathogen.vim](https://github.com/tpope/vim-pathogen).

Scripts
-------

*   Three SSH-related scripts:
    *   `shoal(1)` — Print hostnames read from a `ssh_config(5)` file
    *   `scatter(1)` — Run command on multiple hosts read from `shoal(1)` and
        print output
    *   `shock(1)` — Run command on multiple hosts read from `shoal(1)` and
        print the hostname if the command returns zero
*   `edda(1)` provides a means to run `ed(1)` over a set of files preserving
    any options, mostly useful for scripts. There’s `--help` output and a
    manual page.
*   `han(1)` provides a `keywordprg` for Bash script development that will look
    for `help` topics. You could use it from the shell too. It also has a brief
    manual.
*   `sue(8)` execs `sudoedit(8)` as the owner of all the file arguments given,
    perhaps in cases where you may not necessarily have `root` `sudo(8)`
    privileges.

If you want to use the manuals, you may need to add `~/.local/share/man` to
your `/etc/manpath` configuration, depending on your system.

Testing
-------

You can test that both sets of shell scripts are syntactically correct with
`make test-bash`, `make test-sh`, or `make test` for everything including the
scripts in `bin`.

If you have [ShellCheck](http://www.shellcheck.net/) and/or
[Perl::Critic](http://perlcritic.com), there's a `lint` target for the shell
script files and Perl files respectively. The files don’t need to pass that
check to be installed.

Known issues
------------

I’d welcome patches or advice on fixing any of these problems.

*   The `install-terminfo` target does not work correctly on NetBSD due to the
    different way `tic(1)` works, which I don’t understand at all.

License
-------

Public domain; see the included `UNLICENSE` file. It’s just configuration, do
whatever you like with it if any of it’s useful to you. If you’re feeling
generous, you could always [buy me a coffee](https://sanctum.geek.nz/) next
time you’re in New Zealand.

