#!/bin/bash

I="${DEVENV_IMAGE:-latest}"
[[ $I = *:* ]] || I="dustywilson/devenv:$I"
N="${DEVENV_NAME:-devenv}"
D="${DEVENV_DIR:-$(dirname "$(readlink -f "$0")")}"
P="${DEVENV_PORT:-8880}"

echo
echo "image   = [$I]"
echo "name    = [$N]"
echo "basedir = [$D]"
echo

if [ "$1" == "-r" ]; then
	mkdir -vp \
		"$D/go" \
		"$D/atom" \
		"$D/config"

	docker rm -f $N
	docker run -d \
		--name=$N \
		--restart=always \
		-e DISPLAY=$DISPLAY \
		-v /tmp/.X11-unix/:/tmp/.X11-unix/ \
		-v "$D/go":/user/go \
		-v "$D/atom":/user/.atom \
		-v "$D/config":/user/.config \
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
elif [ "$1" == "-s" -o "$1" == "-x" ]; then
	docker exec -it $N ./entrypoint.sh $*
elif [ "$1" == "-a" -o "$1" == "-v" ]; then
	docker exec $N ./entrypoint.sh $* &
elif [ "$1" == "" -o "$1" == "-h" -o "$1" == "--help" ]; then
	docker exec -it $N ./entrypoint.sh
else
	docker exec -it $N ./entrypoint.sh -x $*
fi
