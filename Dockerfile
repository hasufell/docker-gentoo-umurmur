FROM        mosaiksoftware/gentoo-amd64-paludis:latest
MAINTAINER  Julian Ospald <hasufell@gentoo.org>

##### PACKAGE INSTALLATION #####

RUN chgrp paludisbuild /dev/tty && \
	git -C /usr/portage checkout -- . && \
	env-update && \
	source /etc/profile && \
	cave sync gentoo && \
	cave resolve -c docker-umurmur -x && \
	cave fix-linkage -x && \
	rm -rf /var/cache/paludis/names/* /var/cache/paludis/metadata/* \
		/var/tmp/paludis/* /usr/portage/* /srv/binhost/*

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

