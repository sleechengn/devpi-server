#!/usr/bin/bash
IMAGE_TAG=$1
echo build [$(dirname $0)]  Dockerfile
if [ $IMAGE_TAG ]; then
		docker --debug build $(dirname $0) --file Dockerfile -t $IMAGE_TAG
	else
		docker --debug build $(dirname $0) --file Dockerfile -t sleechengn/devpi-server:latest
fi
