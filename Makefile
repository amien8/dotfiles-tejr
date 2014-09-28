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
	install -d $(HOME)/.config $(HOME)/.bashrc.d
	install bash/bashrc $(HOME)/.bashrc
	install bash/bashrc.d/* $(HOME)/.bashrc.d
	install bash/bash_profile $(HOME)/.bash_profile
	install bash/bash_logout $(HOME)/.bash_logout
	install bash/bash_completion $(HOME)/.config/bash_completion

install-bin : test-bin
	install -d $(HOME)/.local/bin $(HOME)/.local/share/man/man1
	install bin/* $(HOME)/.local/bin
	install man/* $(HOME)/.local/share/man/man1

install-curl :
	install curl/curlrc $(HOME)/.curlrc

install-dircolors :
	install dircolors/dircolors $(HOME)/.dircolors

install-git :
	install git/gitconfig $(HOME)/.gitconfig

install-gnupg :
	install -m 0700 -d $(HOME)/.gnupg
	install -m 0600 gnupg/*.conf $(HOME)/.gnupg

install-i3 :
	install -d $(HOME)/.i3
	install i3/* $(HOME)/.i3

install-mutt :
	install -d $(HOME)/.mutt \
		$(HOME)/.cache/mutt \
		$(HOME)/Mail/inbox/cur \
		$(HOME)/Mail/inbox/new \
		$(HOME)/Mail/inbox/tmp \
		$(HOME)/Mail/sent/cur \
		$(HOME)/Mail/sent/new \
		$(HOME)/Mail/sent/tmp
	install mutt/muttrc $(HOME)/.muttrc
	touch $(HOME)/.mutt/muttrc.local $(HOME)/.mutt/signature

install-ncmcpp :
	install -d $(HOME)/.ncmpcpp
	install ncmpcpp/config $(HOME)/.ncmpcpp/config

install-newsbeuter :
	install -d $(HOME)/.config/newsbeuter $(HOME)/.local/share/newsbeuter
	install newsbeuter/config $(HOME)/.config/newsbeuter/config

install-mysql :
	install mysql/my.cnf $(HOME)/.my.cnf

install-psql :
	install psql/psqlrc $(HOME)/.psqlrc

install-readline :
	install readline/inputrc $(HOME)/.inputrc

install-sh : test-sh
	install -d $(HOME)/.profile.d
	install sh/profile $(HOME)/.profile
	install sh/profile.d/* $(HOME)/.profile.d

install-terminfo :
	for info in terminfo/*.info ; do tic "$$info" ; done

install-task :
	install task/taskrc $(HOME)/.taskrc

install-tmux :
	install tmux/tmux.conf $(HOME)/.tmux.conf

install-urxvt : test-urxvt
	install -d $(HOME)/.urxvt/ext
	install urxvt/ext/* $(HOME)/.urxvt/ext

install-vim :
	install -d $(HOME)/.vim/after/ftplugin \
		$(HOME)/.vim/after/plugin \
		$(HOME)/.vim/autoload \
		$(HOME)/.vim/bundle
	install vim/vimrc $(HOME)/.vimrc
	install vim/gvimrc $(HOME)/.gvimrc
	install vim/after/ftplugin/* $(HOME)/.vim/after/ftplugin
	install vim/after/plugin/* $(HOME)/.vim/after/plugin
	git submodule update --init
	cp -fR vim/bundle/* $(HOME)/.vim/bundle
	rm -f $(HOME)/.vim/after/pathogen.vim
	ln -s $(HOME)/.vim/bundle/pathogen/autoload/pathogen.vim \
		$(HOME)/.vim/autoload/pathogen.vim

install-wyrd :
	install wyrd/wyrdrc $(HOME)/.wyrdrc

install-x : install-i3
	install X/Xmodmap $(HOME)/.Xmodmap
	install X/Xresources $(HOME)/.Xresources
	install X/xsession $(HOME)/.xsession
	install X/xsessionrc $(HOME)/.xsessionrc

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

