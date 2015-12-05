.PHONY: all \
	clean \
	distclean \
	gnupg \
	vim \
	vim-plugins \
	install \
	install-abook \
	install-bash \
	install-bin \
	install-curl \
	install-dircolors \
	install-dunst \
	install-git \
	install-gtk \
	install-gnupg \
	install-gvim \
	install-gvim-config \
	install-i3 \
	install-maildir \
	install-mutt \
	install-mysql \
	install-ncmcpp \
	install-newsbeuter \
	install-perlcritic \
	install-psql \
	install-readline \
	install-sh \
	install-subversion \
	install-task \
	install-terminfo \
	install-tmux \
	install-urxvt \
	install-vim \
	install-vim-config \
	install-vim-pathogen \
	install-vim-plugins \
	install-wyrd \
	install-x \
	test \
	test-bash \
	test-bin \
	test-sh \
	test-urxvt

all : gnupg vim

clean :
	rm -f gnupg/gpg.conf

distclean : clean

gnupg : gnupg/gpg.conf

gnupg/gpg.conf :
	m4 -D DOTFILES_HOME="$(HOME)" gnupg/gpg.conf.m4 > gnupg/gpg.conf

install : install-bash \
	install-curl \
	install-dircolors \
	install-git \
	install-gnupg \
	install-readline \
	install-sh \
	install-terminfo \
	install-vim

install-abook :
	install -m 0755 -d -- \
		"$(HOME)"/.abook
	install -pm 0644 -- abook/abookrc "$(HOME)"/.abook

install-bash : test-bash
	install -m 0755 -d -- \
		"$(HOME)"/.config \
		"$(HOME)"/.bashrc.d \
		"$(HOME)"/.bash_profile.d
	install -pm 0644 -- bash/bashrc "$(HOME)"/.bashrc
	install -pm 0644 -- bash/bashrc.d/* "$(HOME)"/.bashrc.d
	install -pm 0644 -- bash/bash_profile "$(HOME)"/.bash_profile
	install -pm 0644 -- bash/bash_profile.d/* "$(HOME)"/.bash_profile.d
	install -pm 0644 -- bash/bash_logout "$(HOME)"/.bash_logout
	install -pm 0644 -- bash/bash_completion "$(HOME)"/.config/bash_completion

install-bin : test-bin
	install -m 0755 -d -- \
		"$(HOME)"/.local/bin \
		"$(HOME)"/.local/share/man/man1 \
		"$(HOME)"/.local/share/man/man8
	install -m 0755 -- bin/* "$(HOME)"/.local/bin
	install -pm 0644 -- man/man1/* "$(HOME)"/.local/share/man/man1
	install -pm 0644 -- man/man8/* "$(HOME)"/.local/share/man/man8

install-curl :
	install -pm 0644 -- curl/curlrc "$(HOME)"/.curlrc

install-dircolors :
	install -pm 0644 -- dircolors/dircolors "$(HOME)"/.dircolors

install-dunst : install-x
	install -m 0755 -d -- "$(HOME)"/.config/dunst
	install -pm 0644 -- dunst/dunstrc "$(HOME)"/.config/dunst

install-git :
	install -pm 0644 -- git/gitconfig "$(HOME)"/.gitconfig

install-gnupg : gnupg/gpg.conf
	install -m 0700 -d -- \
		"$(HOME)"/.gnupg \
		"$(HOME)"/.gnupg/sks-keyservers.net
	install -pm 0600 -- gnupg/*.conf "$(HOME)"/.gnupg
	install -pm 0644 -- gnupg/sks-keyservers.net/* \
		"$(HOME)"/.gnupg/sks-keyservers.net

install-gtk :
	install -m 0755 -d -- \
		"$(HOME)"/.config/gtkrc-3.0
	install -pm 0644 -- gtk/gtkrc-2.0 "$(HOME)"/.gtkrc-2.0
	install -pm 0644 -- gtk/gtkrc-3.0/settings.ini "$(HOME)"/.config/gtkrc-3.0

install-i3 : install-x
	install -m 0755 -d -- "$(HOME)"/.i3
	install -pm 0644 -- i3/* "$(HOME)"/.i3

install-maildir :
	install -m 0755 -d -- \
		"$(HOME)"/Mail/inbox/cur \
		"$(HOME)"/Mail/inbox/new \
		"$(HOME)"/Mail/inbox/tmp \
		"$(HOME)"/Mail/sent/cur \
		"$(HOME)"/Mail/sent/new \
		"$(HOME)"/Mail/sent/tmp

install-mutt : install-maildir
	install -m 0755 -d -- \
		"$(HOME)"/.mutt \
		"$(HOME)"/.cache/mutt
	install -pm 0644 -- mutt/muttrc "$(HOME)"/.muttrc

install-ncmcpp :
	install -m 0755 -d -- "$(HOME)"/.ncmpcpp
	install -pm 0644 -- ncmpcpp/config "$(HOME)"/.ncmpcpp/config

install-newsbeuter :
	install -m 0755 -d -- \
		"$(HOME)"/.config/newsbeuter \
		"$(HOME)"/.local/share/newsbeuter
	install -pm 0644 -- newsbeuter/config "$(HOME)"/.config/newsbeuter/config

install-mysql :
	install -pm 0644 -- mysql/my.cnf "$(HOME)"/.my.cnf

install-perlcritic:
	install -pm 0644 -- perlcritic/perlcriticrc "$(HOME)"/.perlcriticrc

install-psql :
	install -pm 0644 -- psql/psqlrc "$(HOME)"/.psqlrc

install-readline :
	install -pm 0644 -- readline/inputrc "$(HOME)"/.inputrc

install-sh : test-sh
	install -m 0755 -d -- "$(HOME)"/.profile.d
	install -pm 0644 -- sh/profile "$(HOME)"/.profile
	install -pm 0644 -- sh/profile.d/* "$(HOME)"/.profile.d

install-subversion :
	install -m 0755 -d -- "$(HOME)"/.subversion
	install -pm 0644 -- subversion/config "$(HOME)"/.subversion/config

install-terminfo :
	for info in terminfo/*.info ; do \
		tic -- "$$info" ; \
	done

install-task :
	install -pm 0644 -- task/taskrc "$(HOME)"/.taskrc

install-tmux :
	install -pm 0644 -- tmux/tmux.conf "$(HOME)"/.tmux.conf

install-urxvt : test-urxvt
	install -m 0755 -d -- "$(HOME)"/.urxvt/ext
	install -m 0755 -- urxvt/ext/* "$(HOME)"/.urxvt/ext

install-vim : install-vim-config \
	install-vim-plugins \
	install-vim-pathogen

install-gvim : install-vim \
	install-gvim-config

install-vim-config :
	install -pm 0644 -- vim/vimrc "$(HOME)"/.vimrc

install-gvim-config :
	install -pm 0644 -- vim/gvimrc "$(HOME)"/.gvimrc

install-vim-plugins : vim-plugins install-vim-config
	install -m 0755 -d -- "$(HOME)"/.vim/bundle
	find vim/bundle -name .git -prune -o \
		\( -type d -print \) | \
			while IFS= read -r dir ; do \
				install -m 0755 -d -- \
					"$$dir" "$(HOME)"/.vim/"$${dir#vim/}" ; \
			done
	find vim/bundle -name .git -prune -o \
		\( -type f ! -name '.git*' -print \) | \
			while IFS= read -r file ; do \
				install -pm 0644 -- \
					"$$file" "$(HOME)"/.vim/"$${file#vim/}" ; \
			done
	for dir in vim/after/* ; do \
		install -m 0755 -d -- "$(HOME)"/.vim/after/"$${dir##*/}" ; \
		install -pm 0644 -- "$$dir"/* \
			"$(HOME)"/.vim/after/"$${dir##*/}" ; \
	done

install-vim-pathogen : install-vim-plugins
	install -m 0755 -d -- "$(HOME)"/.vim/autoload
	rm -f -- "$(HOME)"/.vim/autoload/pathogen.vim
	ln -s -- ../bundle/pathogen/autoload/pathogen.vim \
		"$(HOME)"/.vim/autoload/pathogen.vim

install-wyrd :
	install -pm 0644 -- wyrd/wyrdrc "$(HOME)"/.wyrdrc

install-x :
	install -m 0755 -d -- \
		"$(HOME)"/.config \
		"$(HOME)"/.xbackgrounds
	install -pm 0644 -- X/redshift.conf "$(HOME)"/.config/redshift.conf
	install -pm 0644 -- X/backgrounds/* "$(HOME)"/.xbackgrounds
	install -pm 0644 -- X/Xresources "$(HOME)"/.Xresources
	install -pm 0644 -- X/xbindkeysrc "$(HOME)"/.xbindkeysrc
	install -pm 0644 -- X/xinitrc "$(HOME)"/.xinitrc

test : test-sh test-bash test-bin test-urxvt

test-sh :
	@for sh in sh/* sh/profile.d/* ; do \
		if [ -f "$$sh" ] && ! sh -n "$$sh" ; then \
			exit 1 ; \
		fi \
	done
	@printf 'All sh(1) scripts parsed successfully.\n'

test-bash :
	@for bash in bash/* bash/bashrc.d/* bash/bash_profile.d/* ; do \
		if [ -f "$$bash" ] && ! bash -n "$$bash" ; then \
			exit 1 ; \
		fi \
	done
	@printf 'All bash(1) scripts parsed successfully.\n'

test-bin :
	@for bin in bin/* ; do \
		if sed 1q "$$bin" | grep -q bash ; then \
			bash -n "$$bin" || exit 1 ; \
		elif sed 1q "$$bin" | grep -q sh ; then \
			sh -n "$$bin" || exit 1 ; \
		fi ; \
	done
	@printf 'All shell scripts in bin parsed successfully.\n'

test-urxvt:
	@for perl in urxvt/ext/* ; do \
		perl -c "$$perl" >/dev/null || exit 1 ; \
	done
	@printf 'All Perl scripts in urxvt/ext parsed successfully.\n'

lint : lint-sh lint-bash lint-bin lint-urxvt

lint-sh :
	find sh -type f -print -exec shellcheck -- {} \;

lint-bash :
	find bash -type f -print -exec shellcheck -- {} \;

lint-bin :
	find bin -type f -print -exec shellcheck -- {} \;

lint-urxvt:
	find urxvt/ext -type f -print -exec perlcritic --brutal -- {} \;

