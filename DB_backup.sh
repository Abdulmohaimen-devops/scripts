# this script for make DB Mysql 1- backup 2- compress dumps 3- keep only last 10 days backup 4- keep only one version of each file that have the same content ( same md5 )
#!/bin/bash
### MySQL Server Login Info ###
MUSER="root"
MPASS="MyPass"
MHOST="localhost"
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
BAK="/var/backups/mysql_dbs/"
GZIP="$(which gzip)"
NOW=$(date +"%d-%m-%Y")

[ ! -d "$BAK" ] && mkdir -p "$BAK"

# take the backup 
DBS="$($MYSQL -u $MUSER -h $MHOST -p$MPASS -Bse 'show databases')"
for db in $DBS
do
 FILE=$BAK/$db.$NOW-$(date +"%T").gz
 $MYSQLDUMP -u $MUSER -h $MHOST -p$MPASS $db | $GZIP -9 > $FILE
done

#  keep only the last 10 days backups
find   "$BAK" -mtime +9 -delete

# keep only one version of each file that have the same md5
fdupes -r  $BAK  -d  -N
