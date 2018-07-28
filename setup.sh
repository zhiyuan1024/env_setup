#!/bin/bash -e
. apps.sh

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
	echo "==Install APP"
	sleep 1
	for app in $apps; do
		sudo $installer install $app
	done
}

SetupVIM() {
	cwd=$(pwd)
	cd /tmp
	git clone https://github.com/zhiyuan1024/vim_conifg.git
	cd vim_config
	./install install
	cd cwd
}


Init() {
	SetInstaller
}

Run() {
	InstallAPP
	SetupVIM
}

Init
Run
