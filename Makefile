.PHONY: usage install install-bash install-bin install-curl \
	install-dircolors install-git install-gnupg install-i3 \
	install-mutt install-ncmcpp install-newsbeuter install-mysql \
	install-psql install-readline install-sh install-terminfo \
	install-task install-tmux install-urxvt install-vim \
	install-wyrd install-x test test-sh test-bash test-vim test-urxvt

usage :
	@echo "tejr/dotfiles: Nothing to do."
	@echo "Run make -n install, and read the output carefully."
	@echo "If you're happy with what it'll do, then run make install."

install : install-bash \
	install-curl \
	install-dircolors \
	install-git \
	install-gnupg \
	install-readline \
	install-sh \
	install-terminfo \
	install-vim

install-bash : test-bash
	install -m 0755 -d -- $(HOME)/.config $(HOME)/.bashrc.d
	install -m 0644 -- bash/bashrc $(HOME)/.bashrc
	install -m 0644 -- bash/bashrc.d/* $(HOME)/.bashrc.d
	install -m 0644 -- bash/bash_profile $(HOME)/.bash_profile
	install -m 0644 -- bash/bash_logout $(HOME)/.bash_logout
	install -m 0644 -- bash/bash_completion $(HOME)/.config/bash_completion

install-bin : test-bin
	install -m 0755 -d -- $(HOME)/.local/bin $(HOME)/.local/share/man/man1
	install -m 0755 -- bin/* $(HOME)/.local/bin
	install -m 0644 -- man/* $(HOME)/.local/share/man/man1

install-curl :
	install -m 0644 -- curl/curlrc $(HOME)/.curlrc

install-dircolors :
	install -m 0644 -- dircolors/dircolors $(HOME)/.dircolors

install-git :
	install -m 0644 -- git/gitconfig $(HOME)/.gitconfig

install-gnupg :
	install -m 0700 -d -- $(HOME)/.gnupg
	install -m 0600 -- gnupg/*.conf $(HOME)/.gnupg

install-i3 :
	install -m 0755 -d -- $(HOME)/.i3
	install -m 0644 -- i3/* $(HOME)/.i3

install-mutt :
	install -m 0755 -d -- \
		$(HOME)/.mutt \
		$(HOME)/.cache/mutt \
		$(HOME)/Mail/inbox/cur \
		$(HOME)/Mail/inbox/new \
		$(HOME)/Mail/inbox/tmp \
		$(HOME)/Mail/sent/cur \
		$(HOME)/Mail/sent/new \
		$(HOME)/Mail/sent/tmp
	install -m 0644 -- mutt/muttrc $(HOME)/.muttrc
	touch -- $(HOME)/.mutt/muttrc.local $(HOME)/.mutt/signature

install-ncmcpp :
	install -m 0755 -d -- $(HOME)/.ncmpcpp
	install -m 0644 -- ncmpcpp/config $(HOME)/.ncmpcpp/config

install-newsbeuter :
	install -m 0755 -d -- \
		$(HOME)/.config/newsbeuter \
		$(HOME)/.local/share/newsbeuter
	install -m 0644 -- newsbeuter/config $(HOME)/.config/newsbeuter/config

install-mysql :
	install -m 0644 -- mysql/my.cnf $(HOME)/.my.cnf

install-psql :
	install -m 0644 -- psql/psqlrc $(HOME)/.psqlrc

install-readline :
	install -m 0644 -- readline/inputrc $(HOME)/.inputrc

install-sh : test-sh
	install -m 0755 -d -- $(HOME)/.profile.d
	install -m 0644 -- sh/profile $(HOME)/.profile
	install -m 0644 -- sh/profile.d/* $(HOME)/.profile.d

install-terminfo :
	for info in terminfo/*.info ; do \
		tic -- "$$info" ; \
	done

install-task :
	install -m 0644 -- task/taskrc $(HOME)/.taskrc

install-tmux :
	install -m 0644 -- tmux/tmux.conf $(HOME)/.tmux.conf

install-urxvt : test-urxvt
	install -m 0755 -d -- $(HOME)/.urxvt/ext
	install -m 0755 -- urxvt/ext/* $(HOME)/.urxvt/ext

install-vim :
	install -m 0755 -d -- \
		$(HOME)/.vim/after/ftplugin \
		$(HOME)/.vim/after/plugin \
		$(HOME)/.vim/autoload \
		$(HOME)/.vim/bundle
	install -m 0644 -- vim/vimrc $(HOME)/.vimrc
	install -m 0644 -- vim/gvimrc $(HOME)/.gvimrc
	install -m 0644 -- vim/after/ftplugin/* $(HOME)/.vim/after/ftplugin
	install -m 0644 -- vim/after/plugin/* $(HOME)/.vim/after/plugin
	git submodule update --init
	cd vim && find bundle -type d \( -name .git -prune -o -type d -print \) | \
		while IFS= read -r dir ; do \
			install -m 0755 -d -- "$${dir}" $(HOME)/.vim/"$$dir" ; \
		done
	cd vim && find bundle -type f ! -name '.git*' | \
		while IFS= read -r file ; do \
			install -m 0644 -- "$${file}" $(HOME)/.vim/"$$file" ; \
		done
	rm -f -- $(HOME)/.vim/autoload/pathogen.vim
	ln -s -- ../bundle/pathogen/autoload/pathogen.vim \
		$(HOME)/.vim/autoload/pathogen.vim

install-wyrd :
	install -m 0644 -- wyrd/wyrdrc $(HOME)/.wyrdrc

install-x : install-i3
	install -m 0644 -- X/Xmodmap $(HOME)/.Xmodmap
	install -m 0644 -- X/Xresources $(HOME)/.Xresources
	install -m 0644 -- X/xsession $(HOME)/.xsession
	install -m 0644 -- X/xsessionrc $(HOME)/.xsessionrc

test : test-sh test-bash test-bin test-urxvt

test-sh :
	@for sh in sh/* sh/profile.d/* ; do \
		if [ -f "$$sh" ] && ! sh -n "$$sh" ; then \
			exit 1 ; \
		fi \
	done
	@echo "All sh(1) scripts parsed successfully."

test-bash :
	@for bash in bash/* bash/bashrc.d/* ; do \
		if [ -f "$$bash" ] && ! bash -n "$$bash" ; then \
			exit 1 ; \
		fi \
	done
	@echo "All bash(1) scripts parsed successfully."

test-bin :
	@for bin in bin/* ; do \
		if sed 1q "$$bin" | grep -q bash ; then \
			bash -n "$$bin" || exit 1 ; \
		elif sed 1q "$$bin" | grep -q sh ; then \
			sh -n "$$bin" || exit 1 ; \
		fi ; \
	done
	@echo "All shell scripts in bin parsed successfully."

test-urxvt:
	@for perl in urxvt/ext/* ; do \
		perl -c "$$perl" >/dev/null || exit 1 ; \
	done
	@echo "All Perl scripts in urxvt/ext parsed successfully."

