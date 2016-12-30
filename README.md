# build-handbrakecli-in-debian-jessie
Build, create .deb &amp; install Handbrake-cli in debian jessie - optionally using docker

```
git clone https://github.com/notDavid/build-handbrakecli-in-debian-jessie.git
cd build-handbrakecli-in-debian-jessie
docker build -t="docker-handbrakecli" .
# on the host:
mkdir -p ~/tmp/handbrakecli && docker run -t -i -v ~/tmp/handbrakecli:/data docker-handbrakecli bash
# in the container:
cp -v ~/HandBrake/build/*.deb /data/
exit
# on the host, to install HandBrake-cli:
dpkg -i ~/tmp/handbrakecli/*.deb
# on the host, to install missing dependencies:
sudo apt-get install -f
```
