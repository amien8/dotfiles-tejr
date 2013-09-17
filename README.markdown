Dotfiles (Tom Ryder)
====================

Personal repository of dotfiles. This is for those settings that migrate well
from machine to machine and that I consider safe to publish. You’re welcome to
use them, but you’ll probably want to fork it to remove anything peculiar to me
or my setup that I’ve left in here.

    $ git clone git://github.com/tejr/dotfiles.git ~/.dotfiles

It’s more likely you’ll want to read the configuration files and find snippets
relevant to your particular workflow.

Installation
------------

There’s an installation script, but it’s pretty bare-bones, so don’t run it
without reading it first. You’ll need to have a recent enough version of Git to
support [submodules][1] for this to work.

    $ ~/.dotfiles/install

The script will prompt you about replacing old files. If you’re brave/insane,
you can pipe `yes(1)` into it to accept all the replacements:

    $ yes | ~/.dotfiles/install

Tools
-----

Configuration is included for:

*   [ack][2] — Perl alternative to `grep(1)`, including a copy of its
    standalone version
*   [Bash][3] — GNU Bourne-Again Shell, including a `~/.profile` configured to
    work with most Bourne-compatible shells
*   [cURL][4] — Command-line tool for transferring data with URL syntax
*   [Git][5] — Distributed version control system
*   [GnuPG][6] — GNU Privacy Guard, for private communication and file
    encryption
*   [i3][7] — Tiling window manager
*   [Mutt][8] — Terminal mail user agent
*   [Ncmpcpp][9] — ncurses music player client
*   [Newsbeuter][10] — Terminal RSS/Atom feed reader
*   [Perl::Critic][11] — Static analysis tool for Perl code
*   [Readline][12] — GNU library for user input used by Bash, MySQL, and others
*   [Taskwarrior][13] — Command-line task list manager
*   [tmux][14] — Terminal multiplexer similar to GNU Screen
*   [rxvt-unicode][15] — Fork of the rxvt terminal emulator with Unicode
    support
*   [Vim][16] — Vi IMproved, a text editor
*   [X11][17] — Windowing system with network transparency for Unix

The configurations for Bash, Mutt, tmux, and Vim are the most expansive and
most likely to be of interest. The i3 configuration is mostly changed to make
window switching behave like Vim windows and Tmux panes do. There's a fair few
resources defined for rxvt-unicode. Otherwise, the rest of the configuration
isn't too distant from the defaults.

Shell
-----

My `.profile` and other files in `sh` are written in Bourne/POSIX shell script
so that they can be parsed by any Bourne-compatible shell, including the `dash`
shell used as the system shell on modern Debian-derived systems. Individual
scripts called by `.profile` are saved in `.profile.d` and iterated on login
for ease of management. All of these boil down to exporting variables
appropriate to the system and the software it has available.

My interactive and scripting shell of choice is Bash; as a GNU/Linux admin who
ends up installing Bash on BSD machines anyway, I very rarely have to write
Bourne-compatible scripts.

My `.bash_profile` calls `.profile` for variable exports, and then runs
`.bashrc` for interactive shells. Subscripts are kept in `.bashrc.d`, and all
are loaded for the creation of any new interactive shell. The contents of this
directory changes all the time depending on the host, and only specific scripts
in it are versioned; the rest are ignored by `.gitignore`.

As I occasionally have work on very old internal systems, my Bash is written to
work with [any version 2.05a or newer][19], a few versions after the less
error-prone `[[` test syntax was introduced. This is why I use older syntax for
certain things such as appending items to arrays:

```bash
array=("${array[@]}" "$item")
```

Compare this to the much nicer syntax available since 3.1-alpha1, which
actually works for arrays with sparse indexes, unlike the above syntax:

```bash
array+=("$item")
```

Where I do use features that are only available in versions of Bash newer than
2.05a, such as newer `shopt` options or `PROMPT_DTRIM`, they are only run after
testing `BASH_VERSINFO` appropriately.

My prompt generally looks like this, colored bright green:

    [user@hostname:~]$

It expands based on context to include these elements in this order:

*   Whether in a Git, Mercurial, or Subversion repository, and punctuation to
    show whether there are local modifications at a glance
*   The number of running background jobs
*   The exit status of the last command, if non-zero

With all of the above (a rare situation), it might look something like this:

    [user@hostname:~/gitrepo](git:master?){1}<127>$

This is all managed within the `prompt` function. Some of the Git stuff was
adapted from @necolas’ [superb dotfiles][20].

When I use any other Bourne-compatible shell, I’m generally happy to accept its
defaults for interactive behavior.

Mutt
----

My mail is kept in individual Maildirs under `~/Mail`, with `inbox` being where
most unfiltered mail is sent. I use [Getmail][21], [Procmail][22], and
[MSMTP][23]; the configurations for these are not included here. I make heavy
use of GnuPG for email—everything is signed by default, and I encrypt whenever
I have a public key available for the recipient. The GnuPG interfacing is done
with [GPGme][24], rather than defining commands for each crypto operation. I
wrote [an article about this setup][25] if it sounds appealing.

tmux
----

These are just generally vi-friendly settings, not much out of the ordinary.
Note that the configuration presently uses a hard-coded 256-color colorscheme,
and uses subshells rather than login shells, with an attempt to control the
environment to stop shells thinking they have access to an X display—I’m forced
to use PuTTY a lot at work, and I don’t like Xming very much.

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
loaded using @tpope’s [pathogen.vim][26].

License
-------

Public domain. It’s just configuration, do whatever you like with it if any of
it’s useful to you. If you’re feeling generous, you could always buy me a beer
next time you’re in New Zealand.

[1]: http://git-scm.com/book/en/Git-Tools-Submodules
[2]: http://beyondgrep.com/
[3]: https://www.gnu.org/software/bash/
[4]: http://curl.haxx.se/
[5]: http://git-scm.com/
[6]: http://www.gnupg.org/
[7]: http://i3wm.org/
[8]: http://www.mutt.org/
[9]: http://ncmpcpp.rybczak.net/
[10]: http://www.newsbeuter.org/
[11]: http://search.cpan.org/~thaljef/Perl-Critic-1.118/lib/Perl/Critic.pm
[12]: http://cnswww.cns.cwru.edu/php/chet/readline/rltop.html
[13]: http://taskwarrior.org/projects/show/taskwarrior
[14]: http://tmux.sourceforge.net/
[15]: http://software.schmorp.de/pkg/rxvt-unicode.html
[16]: http://www.vim.org/
[17]: http://www.x.org/wiki/
[18]: http://www.perl.com/doc/FMTEYEWTK/versus/csh.whynot
[19]: http://wiki.bash-hackers.org/scripting/bashchanges
[20]: https://github.com/necolas/dotfiles
[21]: http://pyropus.ca/software/getmail/
[22]: http://www.procmail.org/
[23]: http://msmtp.sourceforge.net/
[24]: http://www.gnupg.org/related_software/gpgme/
[25]: http://blog.sanctum.geek.nz/linux-crypto-email/
[26]: https://github.com/tpope/vim-pathogen

