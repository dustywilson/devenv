#!/bin/bash

T="latest-noui"
N="devenv"
D="$(dirname "$(readlink -f "$0")")"

mkdir -vp "$D/go"

if [ "$1" == "-r" ]; then
	docker rm -f $N
	docker run -d \
		--name=$N \
		--restart=always \
		-v "$D/go":/user/go \
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
		emmaly/devenv:$T \
		-x sleep 99999d
elif [ "$1" == "-s" -o "$1" == "-x" ]; then
	docker exec -it $N ./entrypoint.sh $*
elif [ "$1" == "" -o "$1" == "-h" -o "$1" == "--help" ]; then
	docker exec -it $N ./entrypoint.sh
else
	docker exec -it $N ./entrypoint.sh -x $*
fi
