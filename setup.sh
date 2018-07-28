#!/bin/bash -e
. apps.sh
. proxy.sh

installer="yum"
apps=""

SetInstaller() {
	os=$(hostnamectl| grep Operating | awk -F ':' '{print $2}')
	case $os in
		*fedora*|*Fedora*)
			installer="dnf"
			apps=$PRMS
		;;
		*ubuntu*|*elementary*|*Ubuntu*)
			installer="apt"
			app=$DEBS
		;;
	esac
	echo "==user installer: " $installer
}


InstallAPP() {
	echo "==begin to install app"
	sleep 1
	for app in $apps; do
		sudo $installer install -y $app
	done
}

SetupVIM() {
	echo "==begin to set vim"
	cwd=$(pwd)
	cd /tmp
	git clone https://github.com/zhiyuan1024/vim_conifg.git
	cd vim_config
	./install install
	cd cwd
}

SetupZShell() {
	echo "==begin to setup zsh"
	sudo $installer install -y zsh
	export http_proxy=$HTTPProxy
	export https_proxy=$HTTPProxy
	sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	unset http_proxy
	unset https_proxy
}


Init() {
	SetInstaller
	sudo $installer -y upgrade
}

Run() {
	InstallAPP
	SetupZShell
	SetupVIM
}

Init
Run
