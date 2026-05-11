#!/bin/bash

AFP_USER=${AFP_USER:-afpuser}
AFP_PASS=${AFP_PASS:-afpuser}
AFP_UID=${AFP_UID:-9999}

AFP_GROUP=${AFP_GROUP:-afpgroup}
AFP_GID=${AFP_GID:-9999}

function start() {
  echo "Netatalk container starting"

  chmod 775 /var/lock
  chmod 444 /etc/netatalk/atalkd.conf

  if ! id $AFP_USER > /dev/null 2>&1 ; then
    echo "Creating default user"
    groupadd --gid $AFP_GID $AFP_GROUP
    adduser --uid $AFP_UID --gid $AFP_GID --no-create-home --disabled-password --gecos '' $AFP_USER > /dev/null
    usermod -aG $AFP_GROUP $AFP_USER > /dev/null
    echo "$AFP_USER:$AFP_PASS" | chpasswd
    afppasswd -c
    afppasswd -a "$AFP_USER" -f -n -w "$AFP_PASS"
  fi

  #/etc/init.d/timelord start
  /etc/init.d/atalkd start
  /etc/init.d/netatalk start
}

function stop() {
  /etc/init.d/netatalk stop
  /etc/init.d/atalkd stop
  #/etc/init.d/timelord stop
  echo "Netatalk container terminated"
  exit 0
}

start

trap stop TERM INT QUIT
while :; do
    sleep infinity &
    wait $!
done

