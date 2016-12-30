#!/bin/bash
set -ex

apt-get update && apt-get -y upgrade
apt-get -y install autoconf build-essential cmake git libass-dev libbz2-dev libfontconfig1-dev libfreetype6-dev libfribidi-dev libharfbuzz-dev libjansson-dev libmp3lame-dev libogg-dev libopus-dev libsamplerate-dev libtheora-dev libtool libvorbis-dev libx264-dev libxml2-dev m4 make patch python tar yasm zlib1g-dev libtool-bin checkinstall wget

cd
git clone https://github.com/HandBrake/HandBrake.git
cd HandBrake

## By default this will build the latest stable released version.
## To build a specific/nightly version specify it and uncomment here:
#VERSION=master		# = nightly
#VERSION=1.0.1
if [ -z $VERSION ]; then
	STABLE=`wget -q https://github.com/HandBrake/HandBrake/releases/latest -O - | grep -m 1 "<title>Release" | sed -n "s/.*Release[[:blank:]]\([0-9]\{1,2\}\.[0-9]\{1,2\}\.[0-9]\{1,2\}\).*$/\1/p"`
	if ! [ -z $STABLE ]; then
		echo "Scraped the HandBrake release Github page and found the latest version as" ${STABLE}
		VERSION=$STABLE
	else
		exit 1
	fi
fi

git checkout $VERSION
./configure --launch-jobs=$(nproc) --launch --disable-gtk
cd build

PARAM="--pkgname=handbrake-cli "
PARAM+="--requires=\"libass-dev,libbz2-dev,libfontconfig1-dev,libfreetype6-dev,libfribidi-dev,libharfbuzz-dev,libjansson-dev,libmp3lame-dev,libogg-dev,libopus-dev,libsamplerate-dev,libtheora-dev,libtool,libvorbis-dev,libx264-dev,libxml2-dev,m4,python,tar,yasm,zlib1g-dev,libtool-bin\" "
		# some of these requirements may be redundant (the Handbrake build info doesn't specify which are only needed for building..)
if [ "$VERSION" != "master" ]; then
	PARAM+=" --pkgversion=$VERSION"
fi
checkinstall $PARAM

set +x
echo "If you ran this in a Docker container you might want to do this now:"
echo "#1. on the host, execute:"
echo -e "\e[34mmkdir -p ~/tmp/handbrakecli && docker run -t -i -v ~/tmp/handbrakecli:/data docker-handbrakecli bash\e[0m"
echo "#2. in the docker container, execute: "
echo -e "\e[34mcp -v ~/HandBrake/build/*.deb /data/\e[0m"
echo -e "\e[34mexit\e[0m"
echo "#3. on the host, you can now install HandBrake-cli by running:"
echo -e "\e[34mdpkg -i ~/tmp/handbrakecli/*.deb\e[0m"
echo "#4. on the host, to install missing dependencies:"
echo -e "\e[34msudo apt-get install -f \e[0m"
