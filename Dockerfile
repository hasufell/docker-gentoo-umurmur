FROM        mosaiksoftware/gentoo-amd64-paludis:latest
MAINTAINER  Julian Ospald <hasufell@gentoo.org>

##### PACKAGE INSTALLATION #####

# install nginx
RUN chgrp paludisbuild /dev/tty && cave resolve -c docker-umurmur -x && \
	rm -rf /usr/portage/distfiles/* /srv/binhost/*

# update etc files... hope this doesn't screw up
RUN etc-update --automode -5

################################

COPY ./config/umurmur.conf /etc/umurmur/umurmur.conf
RUN mkdir /umurmurconfig
COPY ./config/channels.conf /umurmurconfig/

COPY ./setup.sh /setup.sh
RUN chmod +x /setup.sh
COPY ./config/supervisord.conf /etc/supervisord.conf

EXPOSE 64738

CMD /setup.sh && exec /usr/bin/supervisord -n -c /etc/supervisord.conf
