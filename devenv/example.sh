#!/bin/bash

N="devenv"
D="$(dirname "$(readlink -f "$0")")"

mkdir -vp \
	"$D/go" \
	"$D/atom" \
	"$D/config"

if [ "$1" == "-r" ]; then
	docker rm -f $N
	docker run -d \
		--name=$N \
		--restart=always \
		-e DISPLAY=$DISPLAY \
		-v /tmp/.X11-unix/:/tmp/.X11-unix/ \
		-v "$D/go":/user/go \
		-v "$D/atom":/user/.atom \
		-v "$D/config":/user/.config \
		-p 0.0.0.0:8880:8880 \
		-p 0.0.0.0:8881:8881 \
		-p 0.0.0.0:8882:8882 \
		-p 0.0.0.0:8883:8883 \
		-p 0.0.0.0:8884:8884 \
		-p 0.0.0.0:8885:8885 \
		-p 0.0.0.0:8886:8886 \
		-p 0.0.0.0:8887:8887 \
		-p 0.0.0.0:8888:8888 \
		-p 0.0.0.0:8889:8889 \
		dustywilson/devenv \
		-x sleep 99999d
elif [ "$1" == "-s" -o "$1" == "-x" ]; then
	docker exec -it $N ./entrypoint.sh $*
elif [ "$1" == "-a" ]; then
	docker exec $N ./entrypoint.sh $* &
elif [ "$1" == "" -o "$1" == "-h" -o "$1" == "--help" ]; then
	docker exec -it $N ./entrypoint.sh
else
	docker exec -it $N ./entrypoint.sh -x $*
fi
