install : install-ack \
	install-bash \
	install-curl \
	install-git \
	install-gnupg \
	install-readline \
	install-sh \
	install-terminfo \
	install-vim

install-ack :
	mkdir -p $(HOME)/.local/bin
	rm -fr $(HOME)/.local/bin/ack $(HOME)/.ackrc
	ln -s $(PWD)/ack/ack $(HOME)/.local/bin/ack
	ln -s $(PWD)/ack/ackrc $(HOME)/.ackrc

install-bash :
	mkdir -p $(HOME)/.config
	rm -f $(HOME)/.bashrc $(HOME)/.bash_profile \
		$(HOME)/.bash_logout $(HOME)/.config/bash_completion
	rm -fr $(HOME)/.bashrc.d
	ln -s $(PWD)/bash/bashrc $(HOME)/.bashrc
	ln -s $(PWD)/bash/bashrc.d $(HOME)/.bashrc.d
	ln -s $(PWD)/bash/bash_profile $(HOME)/.bash_profile
	ln -s $(PWD)/bash/bash_logout $(HOME)/.bash_logout
	ln -s $(PWD)/bash/bash_completion $(HOME)/.config/bash_completion

install-curl :
	rm -f $(HOME)/.curlrc
	ln -s $(PWD)/curl/curlrc $(HOME)/.curlrc

install-git :
	rm -f $(HOME)/.gitconfig
	ln -s $(PWD)/git/gitconfig $(HOME)/.gitconfig

install-gnupg :
	mkdir -p $(HOME)/.gnupg
	rm -f $(HOME)/.gnupg/gpg.conf $(HOME)/.gnupg/gpg-agent.conf
	ln -s $(PWD)/gnupg/gpg.conf $(HOME)/.gnupg/gpg.conf
	ln -s $(PWD)/gnupg/gpg-agent.conf $(HOME)/.gnupg/gpg-agent.conf

install-i3 :
	mkdir -p $(HOME)/.i3
	rm -f $(HOME)/.i3/config $(HOME)/.i3/status $(HOME)/.i3/draugen.jpg
	ln -s $(PWD)/i3/config $(HOME)/.i3/config
	ln -s $(PWD)/i3/status $(HOME)/.i3/status
	ln -s $(PWD)/i3/draugen.jpg $(HOME)/.i3/draugen.jpg

install-mutt :
	mkdir -p $(HOME)/.mutt $(HOME)/.cache/mutt
	mkdir -p $(HOME)/Mail/inbox/cur \
		$(HOME)/Mail/inbox/new \
		$(HOME)/Mail/inbox/tmp
	mkdir -p $(HOME)/Mail/sent/cur \
		$(HOME)/Mail/sent/new \
		$(HOME)/Mail/sent/tmp
	rm -f $(HOME)/.muttrc
	ln -s $(PWD)/mutt/muttrc $(HOME)/.muttrc
	touch $(HOME)/.mutt/muttrc.local $(HOME)/.mutt/signature

install-ncmcpp :
	mkdir -p $(HOME)/.ncmpcpp
	rm -f $(HOME)/.ncmpcpp/config
	ln -s $(PWD)/ncmpcpp/config $(HOME)/.ncmpcpp/config

install-newsbeuter :
	mkdir -p $(HOME)/.config/newsbeuter $(HOME)/.local/share/newsbeuter
	rm -f $(HOME)/.config/newsbeuter/config
	ln -s $(PWD)/newsbeuter/config $(HOME)/.config/newsbeuter/config

install-mysql :
	rm -f $(HOME)/.my.cnf
	ln -s $(PWD)/mysql/my.cnf $(HOME)/.my.cnf

install-perl :
	rm -f $(HOME)/.perlcriticrc
	ln -s $(PWD)/perl/perlcriticrc $(HOME)/.perlcriticrc

install-psql :
	rm -f $(HOME)/.psqlrc
	ln -s $(PWD)/psql/psqlrc $(HOME)/.psqlrc

install-readline :
	rm -f $(HOME)/.inputrc
	ln -s $(PWD)/readline/inputrc $(HOME)/.inputrc

install-sh :
	rm -f $(HOME)/.profile
	rm -fr $(HOME)/.profile.d
	ln -s $(PWD)/sh/profile $(HOME)/.profile
	ln -s $(PWD)/sh/profile.d $(HOME)/.profile.d

install-terminfo :
	for info in $(PWD)/terminfo/*.info ; do tic "$$info" ; done

install-tmux :
	rm -f $(HOME)/.tmux.conf
	ln -s $(PWD)/tmux/tmux.conf $(HOME)/.tmux.conf

install-urxvt :
	mkdir -p $(HOME)/.urxvt
	rm -f $(HOME)/.urxvt/clip
	ln -s $(PWD)/urxvt/clip $(HOME)/.urxvt/clip

install-vim :
	mkdir -p $(HOME)/.vim
	rm -fr $(HOME)/.vim/after $(HOME)/.vim/autoload $(HOME)/.vim/bundle
	rm -f $(HOME)/.vimrc $(HOME)/.gvimrc
	ln -s $(PWD)/vim/after $(HOME)/.vim/after
	ln -s $(PWD)/vim/autoload $(HOME)/.vim/autoload
	ln -s $(PWD)/vim/bundle $(HOME)/.vim/bundle
	ln -s $(PWD)/vim/vimrc $(HOME)/.vimrc
	ln -s $(PWD)/vim/gvimrc $(HOME)/.gvimrc
	(cd $(PWD) && git submodule update --init)

install-wyrd :
	rm -f $(HOME)/.wyrdrc
	ln -s $(PWD)/wyrd/wyrdrc $(HOME)/.wyrdrc

install-x : install-i3
	rm -f $(HOME)/.Xmodmap $(HOME)/.Xresources \
		$(HOME)/.xsession $(HOME)/.xsessionrc
	ln -s $(PWD)/X/Xmodmap $(HOME)/.Xmodmap
	ln -s $(PWD)/X/Xresources $(HOME)/.Xresources
	ln -s $(PWD)/X/xsession $(HOME)/.xsession
	ln -s $(PWD)/X/xsessionrc $(HOME)/.xsessionrc

