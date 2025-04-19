from ubuntu:jammy

#APT-PLACE-HOLDER

run apt update \
	&& apt install -y curl aria2 \
	&& apt clean

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
	&& uv pip install "devpi-server"

run curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
run mkdir /opt/filebrowser

RUN apt update
RUN apt install -y nginx ttyd
RUN rm -rf /etc/nginx/sites-enabled/default
ADD ./NGINX /etc/nginx/sites-enabled/

RUN . /opt/venv/bin/activate \
	&& devpi-init

copy ./docker-entrypoint.sh /
run chmod +x /docker-entrypoint.sh
cmd []
entrypoint ["/docker-entrypoint.sh"]
