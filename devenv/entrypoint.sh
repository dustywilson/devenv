#!/bin/bash

if [ ! -d "$HOME/.atom" ]; then
	cat "$HOME/example.sh"
	exit 1
fi

export USER="$(whoami)"

if [ "$USER" != "root" ]; then
	for PKG in \
		go-plus \
		go-debug \
		go-signature-statusbar \
		hyperclick \
		linter \
		linter-ui-default \
		intentions \
		busy-signal \
		language-protobuf \
		teletype
		do [ ! -d "$HOME/.atom/packages/$PKG" ] && apm install $PKG
	done
fi

[ "$TERM" == "dumb" ] && TERM=""
export TERM=${TERM:-linux}
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export APPENGINEPATH=$HOME/go_appengine
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin:$APPENGINEPATH:$HOME/.npm-global/bin

mkdir -p $GOPATH/src

if [ "$USER" != "root" -a ! -d "$GOPATH/src/google.golang.org/grpc" ]; then
	go get -u google.golang.org/grpc
fi

if [ "$USER" != "root" -a ! -d "$GOPATH/src/github.com/derekparker/delve/cmd/dlv" ]; then
	go get -u github.com/derekparker/delve/cmd/dlv
fi

if [ "$USER" != "root" -a ! -d "$GOPATH/src/github.com/golang/protobuf/protoc-gen-go" ]; then
	go get -u github.com/golang/protobuf/protoc-gen-go
fi

if [ "$1" == "-x" ]; then
	# arg1 is -x, then the user wanted to run a command
	# you'll want to `docker run` or `docker exec` with `-it` flag, or this won't likely work so well
	shift
	cd $HOME
	$*
elif [ "$1" == "-s" ]; then
	shift
	if [ -e "$1" ]; then
		# arg1 is an existing directory, open shell with that directory
		cd "$1"
		/bin/bash
	elif [ -e "$GOPATH/src/$1" ]; then
		# arg1 is an existing Go package, open shell with that directory
		cd "$GOPATH/src/$1"
		/bin/bash
	else
		# no arg1 (or dir was not found), just open a shell at ~/go/src
		cd /user/go/src
		/bin/bash
	fi
elif [ "$1" == "-a" ]; then
	shift
	if [ -e "$1" ]; then
		# arg1 is an existing directory, open Atom with that directory
		atom -w "$1"
	elif [ -e "$GOPATH/src/$1" ]; then
		# arg1 is an existing Go package, open Atom with that directory
		atom -w "$GOPATH/src/$1"
	else
		# run Atom with the go/src directory open (because we didn't find the requested dir, or there was none requested)
		atom -w $GOPATH/src
	fi
else
	# something else, give help
	echo "Usage:"
	echo "  (no arguments)		this help screen, then exit"
	echo "  -x <somecommand>	to run a command"
	echo "  -s			to run a shell at go/src dir"
	echo "  -s <dir-path>		to run a shell at that dir"
	echo "  -s <go-package-name>	to run a shell at that Go package dir"
	echo "  -a			to run Atom with go/src dir"
	echo "  -a <file-or-dir-path>	to run Atom with that file or dir"
	echo "  -a <go-package-name>	to run Atom with that Go package"
fi
