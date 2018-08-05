#!/bin/bash

ODIR=$(dirname "$(readlink -f "$0")")
FNAM=$(basename "$0" .sh)
[ -f "${ODIR}/${FNAM}.conf" ] && source "${ODIR}/${FNAM}.conf"

I="${DEVENV_IMAGE:-latest}"
[[ $I = *:* ]] || I="emmaly/devenv:$I"
N="${DEVENV_NAME:-devenv}"
D="${DEVENV_DIR:-${ODIR}}"
P="${DEVENV_PORT:-8880}"
R="$(docker ps -q --filter "name=^/${N}$")"
E="$(docker ps -aq --filter "name=^/${N}$")"
U=""

#if [[ $1 = -u* ]]; then
#	U=${1/#-u/}
#	shift;
#	if [ -z "$U" ]; then
#		if [[ ! $1 = -* ]]; then
#			U=$1
#			shift;
#		fi
#	fi
#fi

echo
echo "image    = [$I]"
echo "name     = [$N]"
echo "basedir  = [$D]"
echo "baseport = [$P]"
echo "running  = [$R]"
echo "existing = [$E]"
#[ ! -z "$U" ] && echo "user     = [$U]"
echo

#[ ! -z "$U" ] && U="-u $U"

if [ "$1" == "-destroy" ]; then
	if [ -z "$E" ]; then
		echo "Unable to destroy [$N] as it doesn't exist."
		exit 1
	fi
	echo "Destroying [$N]..."
	docker rm -f $N
	exit
elif [ "$1" == "-r" ]; then
	mkdir -vp \
		"$D/go" \
		"$D/atom" \
		"$D/vscode" \
		"$D/config" \
		"$D/local_share" \

	[ ! -z "$E" ] && docker rm -f $N
	docker run -d \
		--name=$N \
		--restart=always \
		--ipc=host \
		-e DISPLAY=$DISPLAY \
		-v /tmp/.X11-unix/:/tmp/.X11-unix/ \
		-v "$D/go":/user/go \
		-v "$D/atom":/user/.atom \
		-v "$D/vscode":/user/.vscode \
		-v "$D/config":/user/.config \
		-v "$D/local_share":/user/.local/share \
		-p 0.0.0.0:$(( ${P} + 0 )):$(( ${P} + 0 )) \
		-p 0.0.0.0:$(( ${P} + 1 )):$(( ${P} + 1 )) \
		-p 0.0.0.0:$(( ${P} + 2 )):$(( ${P} + 2 )) \
		-p 0.0.0.0:$(( ${P} + 3 )):$(( ${P} + 3 )) \
		-p 0.0.0.0:$(( ${P} + 4 )):$(( ${P} + 4 )) \
		-p 0.0.0.0:$(( ${P} + 5 )):$(( ${P} + 5 )) \
		-p 0.0.0.0:$(( ${P} + 6 )):$(( ${P} + 6 )) \
		-p 0.0.0.0:$(( ${P} + 7 )):$(( ${P} + 7 )) \
		-p 0.0.0.0:$(( ${P} + 8 )):$(( ${P} + 8 )) \
		-p 0.0.0.0:$(( ${P} + 9 )):$(( ${P} + 9 )) \
		"$I" \
		-x sleep 99999d
elif [ -z "$E" ]; then
	echo "Container [$N] does not exist.  Perhaps you should run: ${0} -r"
	exit 1
elif [ -z "$R" ]; then
	echo "Container [$N] exists, but is not running.  Maybe run: docker start ${N}"
	exit 1
elif [ "$1" == "-S" ]; then
	# root shell
	docker exec -u root -it $N /bin/bash
else
	if [ "$1" == "-s" -o "$1" == "-x" ]; then
		docker exec $U -it $N /user/entrypoint.sh $*
	elif [ "$1" == "-X" ]; then
		shift;
		docker exec $U $N /user/entrypoint.sh -x $* &
	elif [ "$1" == "-a" -o "$1" == "-v" ]; then
		docker exec $U $N /user/entrypoint.sh $* &
	elif [ "$1" == "" -o "$1" == "-h" -o "$1" == "--help" ]; then
		docker exec $U -it $N /user/entrypoint.sh
	else
		docker exec $U -it $N /user/entrypoint.sh -x $*
	fi
fi
