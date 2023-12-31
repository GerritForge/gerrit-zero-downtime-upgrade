#!/bin/bash -e

if [[ ! -z "$WAIT_FOR" ]]
then
  wait-for-it.sh $WAIT_FOR -t 600 -- echo "$WAIT_FOR is up"
fi

sudo -u gerrit cp /var/gerrit/etc/gerrit.config.orig /var/gerrit/etc/gerrit.config
git config -f /var/gerrit/etc/gerrit.config gerrit.serverId 5da66330-1860-4f08-a889-27664fe55d85
sudo -u gerrit cp /var/gerrit/etc/high-availability.config.orig /var/gerrit/etc/high-availability.config

if [[ ! -f /var/gerrit/etc/ssh_host_ed25519_key ]]
then
  echo "Initializing Gerrit site ..."
  sudo -u gerrit java -jar /var/gerrit/bin/gerrit.war init -d /var/gerrit --batch
  chown -R gerrit: /var/gerrit/shareddir
fi

sudo -u gerrit git config -f /var/gerrit/etc/gerrit.config gerrit.canonicalWebUrl http://$HOSTNAME/

sudo -u gerrit touch /var/gerrit/logs/{gc_log,error_log,httpd_log,sshd_log,replication_log} && tail -f /var/gerrit/logs/* | grep --line-buffered -v 'HEAD /' &

echo "Running Gerrit ..."
sudo -u gerrit /var/gerrit/bin/gerrit.sh run
