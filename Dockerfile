# build handbrake-cli
#
# VERSION 0.0.1

FROM debian:latest
MAINTAINER David <https://github.com/notDavid>

#build info: https://handbrake.fr/docs/en/latest/developer/build-linux.html

ADD         build-handbrakecli.sh /tmp/
RUN         chmod +x /tmp/build-handbrakecli.sh
RUN         /tmp/build-handbrakecli.sh | tee /root/buildlog.handbrakecli.log
