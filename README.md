devpi是一个pypi服务器，可用于镜像

devpi-server通过devpi客户端进行管理

安装
pip install devpi
初始化
devpi-init
带root密码服务器配置的初始化
devpi-init --serverdir /opt/devs --root-passwd root

运行
devpi-server --serverdir /opt/devs --host=0.0.0.0

登录镜像
```
devpi use http://192.168.13.86:3141
devpi login root
#输入密码，root
devpi index root/pypi mirror_url="https://download.pytorch.org/whl/cu126"
```
查看
```
devpi index root/pypi
```
创建
```
#创建普通的index
devpi index -c root/cu126
```
#注意以上创建的不是mirror

#创建mirror的
```
#cuda 12.6 torch
devpi index -c root/cu126 type=mirror mirror_url="https://download.pytorch.org/whl/cu126" volatile=False
```
```
#cuda 12.4 torch
devpi index -c root/cu124 type=mirror mirror_url="https://download.pytorch.org/whl/cu124" volatile=False
```
编辑已经存在的
```
devpi index root/cu126 volatile=False
```
删除
```
devpi index --delete root/cu126
```
#设置易变删除
```
devpi index root/tspi volatile=True
devpi index --delete root/tspi
```
pip客户端安装包
uv pip install torch --index-url http://192.168.13.86:3141/root/pypi --extra-index-url http://192.168.13.86:3141/root/cu126 --allow-insecure-host=192.168.13.86
pip install torch --index-url http://192.168.13.86:3141/root/pypi --extra-index-url http://192.168.13.86:3141/root/cu126 --trusted-host=192.168.13.86 --force
uv pip install cowsay --index-url http://192.168.13.86:3141/root/pypi --extra-index-url http://192.168.13.86:3141/root/cu126 --allow-insecure-host=192.168.13.86

docker compose
```
networks:
  name: lan13
    driver: macvlan
    driver_opts:
      parent: eth1
    ipam:
      config:
        - subnet: "192.168.13.0/24"
          gateway: "192.168.13.1"
services:
  devpi-server:
    container_name: "devpi-server"
    hostname: "devpi-server"
    image: "192.168.13.73:5000/sleechengn/devpi-server:latest"
    restart: always
    environment:
      - TZ=Asia/Shanghai
      - HF_ENDPOINT=https://hf-mirror.com
      - PIP_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple
      - PIP_EXTRA_INDEX_URL=https://download.pytorch.org/whl/cu126
      - LC_ALL=zh_CN.UTF-8
    volumes:
      - "/mnt/rfs:/mnt/rfs"
      - "devpi-server-data:/opt/devpi-server"
    networks:
      lan13:
        ipv4_address: 192.168.13.86
volumes:
  devpi-server-data:
    name: devpi-server-data
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ./data/devpi-server
```
