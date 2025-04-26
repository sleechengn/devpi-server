from ubuntu:jammy

#APT_CN_UBUNTU_JAMMY

run apt update \
	&& apt install -y curl aria2 nginx ttyd \
	&& apt clean

run curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
run mkdir /opt/filebrowser

RUN rm -rf /etc/nginx/sites-enabled/default
ADD ./NGINX /etc/nginx/sites-enabled/

run set -e \
	&& mkdir /opt/uv \
	&& cd /opt/uv \
	&& aria2c -x 10 -j 10 -k 1M "https://github.com/astral-sh/uv/releases/download/0.6.14/uv-x86_64-unknown-linux-gnu.tar.gz" -o "uv.tar.gz" \
	&& tar -zxvf uv.tar.gz \
	&& rm -rf uv.tar.gz \
	&& ln -s /opt/uv/uv-x86_64-unknown-linux-gnu/uv /usr/bin/uv \
	&& ln -s /opt/uv/uv-x86_64-unknown-linux-gnu/uvx /usr/bin/uvx

run set -e \
	&& uv venv /opt/venv --python 3.12 --seed

run set -e \
	&& . /opt/venv/bin/activate \
	&& uv pip install "devpi"


RUN . /opt/venv/bin/activate \
	&& devpi-init --serverdir /opt/devpi-server --root-passwd root

copy ./docker-entrypoint.sh /
run chmod +x /docker-entrypoint.sh
volume /opt/devpi-server
cmd []
entrypoint ["/docker-entrypoint.sh"]
