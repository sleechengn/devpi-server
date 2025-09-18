from ubuntu:jammy

#APT_CN_UBUNTU_JAMMY

run apt update \
	&& apt install -y curl aria2 nginx tmux lrzsz \
	&& apt clean

# ttyd
run set -e \
	&& mkdir -p /opt/ttyd \
	&& cd /opt/ttyd \
	&& DOWNLOAD=$(curl -s https://api.github.com/repos/tsl0922/ttyd/releases/latest | grep browser_download_url |grep ttyd.x86_64| cut -d'"' -f4) \
	&& aria2c -x 10 -j 10 -k 1m $DOWNLOAD -o ttyd.x86_64 \
	&& chmod +x ttyd.x86_64 \
	&& ln -s $(pwd)/ttyd.x86_64 /usr/bin/ttyd.x86_64

# filebrowser                                                                                                                                                                                                               
run mkdir /opt/filebrowser \                                                                                                                                                                                                                                           
        && cd /opt/filebrowser\                                                                                                                                                                                                                                        
        && DOWNLOAD=$(curl -s https://api.github.com/repos/filebrowser/filebrowser/releases/latest | grep browser_download_url |grep linux|grep amd64| grep -v rocm| cut -d'"' -f4) \                                                                                  
        && aria2c -x 10 -j 10 -k 1M $DOWNLOAD -o linux-amd64-filebrowser.tar.gz \                                                                                                                                                                                      
        && tar -zxvf linux-amd64-filebrowser.tar.gz \                                                                                                                                                                                                                  
        && rm -rf linux-amd64-filebrowser.tar.gz \                                                                                                                                                                                                                     
        && ln -s $(pwd)/filebrowser /usr/bin/filebrowser

run rm -rf /etc/nginx/sites-enabled/default
add ./NGINX /etc/nginx/sites-enabled/

run set -e \
	&& mkdir /opt/uv \
	&& cd /opt/uv \
	&& aria2c -x 10 -j 10 -k 1M "https://github.com/astral-sh/uv/releases/download/0.6.14/uv-x86_64-unknown-linux-gnu.tar.gz" -o "uv.tar.gz" \
	&& tar -zxvf uv.tar.gz \
	&& rm -rf uv.tar.gz \
	&& ln -s $(pwd)/$(ls -A .)/uv /usr/bin/uv \
	&& ln -s $(pwd)/$(ls -A .)/uvx /usr/bin/uvx

# trzsz
RUN set -e \
        && mkdir /opt/trzsz && cd /opt/trzsz \
        && DOWNLOAD=$(curl -s https://api.github.com/repos/trzsz/trzsz-go/releases/latest | grep browser_download_url |grep linux_x86_64|grep tar| cut -d'"' -f4) \
        && aria2c -x 10 -j 10 -k 1m $DOWNLOAD -o bin.tar.gz \
        && tar -zxvf bin.tar.gz \
        && rm -rf bin.tar.gz \
        && BIN_DIR=$(pwd)/$(ls -A .) \
        && ln -s $BIN_DIR/trzsz /usr/bin/trzsz \
        && ln -s $BIN_DIR/trz /usr/bin/trz \
        && ln -s $BIN_DIR/tsz /usr/bin/tsz

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
