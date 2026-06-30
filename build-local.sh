#!/usr/bin/env bash
mkdir -p /opt/tmp
rm -rf /opt/tmp/devpi-server-build
cp -ra . /opt/tmp/devpi-server-build
cd /opt/tmp/devpi-server-build
rm -rf .git

sed -i '/from debian:trixie/i\# HEAD LINE' Dockerfile
sed -i '/from debian:trixie/a\# RUN LINE' Dockerfile

sed -i 's#from debian:trixie#from 192.168.13.73:5000/debian:trixie#g' Dockerfile

sed -i '/# HEAD LINE/i\# syntax=192.168.13.73:5000/docker/dockerfile:1.3' Dockerfile

sed -i '/# RUN LINE/i\run apt update' Dockerfile
sed -i '/# RUN LINE/i\run apt install -y apt-transport-https ca-certificates' Dockerfile
sed -i '/# RUN LINE/i\run sed -i "s,http://deb.debian.org/,https://mirrors.tuna.tsinghua.edu.cn/,g" /etc/apt/sources.list.d/debian.sources' Dockerfile
sed -i '/# RUN LINE/i\run apt update' Dockerfile

docker --debug build . -f Dockerfile -t 192.168.13.73:5000/sleechengn/devpi-server:latest
docker push 192.168.13.73:5000/sleechengn/devpi-server:latest
docker --debug build . -f Dockerfile -t sleechengn/devpi-server:latest