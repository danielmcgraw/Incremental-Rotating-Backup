#!/bin/bash
# This script creates a week long rotating backup of the work
# at the PATH for the USER on the HOST that you specify.
# Can be run by hand, but would suggest creating a cron job.
 
 
# Vars
# Your user name on the remote machine (e.g. bob).
USERNAME='username' 
# The remote machines hostname (e.g. www.yoursite.com).
HOSTNAME='hostname' 
# The path to the folder you want to back up (e.g. /home/bob)
DIRPATH='path' 
 
# Check to make sure the folders exist, if not creates them.
/bin/mkdir -p backup.{0..7}
 
# Delete the oldest backup folder.
/bin/rm -rf backup.7
 
# Shift all the backup folders up a day.
for i in {7..1}
do
  /bin/mv backup.$[${i}-1] backup.${i}
done
 
# Create the new backup hard linking with the previous backup.
# This allows for the least amount of data possible to be 
# transfered while maintaining a complete backup.
/usr/bin/rsync -a -e ssh -z --delete --link-dest=../backup.1 ${USERNAME}@${HOSTNAME}:${DIRPATH} backup.0/