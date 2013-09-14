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
*   [awesome][3] — Tiling window manager
*   [Bash][4] — GNU Bourne-Again Shell, including a `~/.profile` configured to
    work with most Bourne-compatible shells
*   [cURL][5] — Command-line tool for transferring data with URL syntax
*   [Git][6] — Distributed version control system
*   [GnuPG][7] — GNU Privacy Guard, for private communication and file
    encryption
*   [Mutt][8] — Terminal mail user agent
*   [Newsbeuter][9] — Terminal RSS/Atom feed reader
*   [Perl::Critic][10] — Static analysis tool for Perl code
*   [Readline][11] — GNU library for user input used by Bash, MySQL, and others
*   [Taskwarrior][12] — Command-line task list manager
*   [tmux][13] — Terminal multiplexer similar to GNU Screen
*   [rxvt-unicode][14] — Fork of the rxvt terminal emulator with Unicode
    support
*   [Vim][15] — Vi IMproved, a text editor
*   [X11][16] — Windowing system with network transparency for Unix

The configurations for Bash, Mutt, tmux, and Vim are the most expansive and
most likely to be of interest. The rest of the configurations are relatively
minimal changes to defaults that annoyed me.

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
work with [any version 2.05a or newer][18], a few versions after the less
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
adapted from @necolas’ [superb dotfiles][19].

When I use any other Bourne-compatible shell, I’m generally happy to accept its
defaults for interactive behavior.

Mutt
----

My mail is kept in individual Maildirs under `~/Mail`, with `inbox` being where
most unfiltered mail is sent. I use [Getmail][20], [Procmail][21], and
[MSMTP][22]; the configurations for these are not included here. I make heavy
use of GnuPG for email—everything is signed by default, and I encrypt whenever
I have a public key available for the recipient. The GnuPG interfacing is done
with [GPGme][23], rather than defining commands for each crypto operation. I
wrote [an article about this setup][24] if it sounds appealing.

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
loaded using @tpope’s [pathogen.vim][25].

License
-------

Public domain. It’s just configuration, do whatever you like with it if any of
it’s useful to you. If you’re feeling generous, you could always buy me a beer
next time you’re in New Zealand.

[1]: http://git-scm.com/book/en/Git-Tools-Submodules
[2]: http://beyondgrep.com/
[3]: http://awesome.naquadah.org/
[4]: https://www.gnu.org/software/bash/
[5]: http://curl.haxx.se/
[6]: http://git-scm.com/
[7]: http://www.gnupg.org/
[8]: http://www.mutt.org/
[9]: http://www.newsbeuter.org/
[10]: http://search.cpan.org/~thaljef/Perl-Critic-1.118/lib/Perl/Critic.pm
[11]: http://cnswww.cns.cwru.edu/php/chet/readline/rltop.html
[12]: http://taskwarrior.org/projects/show/taskwarrior
[13]: http://tmux.sourceforge.net/
[14]: http://software.schmorp.de/pkg/rxvt-unicode.html
[15]: http://www.vim.org/
[16]: http://www.x.org/wiki/
[17]: http://www.perl.com/doc/FMTEYEWTK/versus/csh.whynot
[18]: http://wiki.bash-hackers.org/scripting/bashchanges
[19]: https://github.com/necolas/dotfiles
[20]: http://pyropus.ca/software/getmail/
[21]: http://www.procmail.org/
[22]: http://msmtp.sourceforge.net/
[23]: http://www.gnupg.org/related_software/gpgme/
[24]: http://blog.sanctum.geek.nz/linux-crypto-email/
[25]: https://github.com/tpope/vim-pathogen
[26]: http://www.sanctum.geek.nz/about/tom-ryder
[27]: http://www.opensource.org/licenses/MIT

