#!/bin/bash

set -e

# strings
for i in welcometext certificate private_key ca_path password \
		admin_password banfile bindaddr bindaddr6 logfile \
		username groupname; do
	if [[ ${!i} ]] ; then
		sed -i \
			-e "s|${i} = .*|${i} = \"${!i}\";|" \
			-e "s|# ${i} = .*|${i} = \"${!i}\";|" \
			-e "s|#${i} = .*|${i} = \"${!i}\";|" \
			/etc/umurmur/umurmur.conf
	fi
done

unset i

# integers and booleans
for i in max_bandwidth ban_length enable_ban sync_banfile allow_textmessage \
		opus_threshold max_users bindport bindport6; do
	if [[ ${!i} ]] ; then
		sed -i \
			-e "s|${i} = .*|${i} = ${!i};|" \
			-e "s|# ${i} = .*|${i} = ${!i};|" \
			-e "s|#${i} = .*|${i} = ${!i};|" \
			/etc/umurmur/umurmur.conf
	fi
done

unset i

if ! grep -E '^channels =.*' /etc/umurmur/umurmur.conf ; then
	cat /umurmurconfig/channels.conf >> /etc/umurmur/umurmur.conf
fi
