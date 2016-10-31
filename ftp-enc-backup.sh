#!/bin/bash
#
# Author: Sven Festersen <sven@sven-festersen.de>
#
# A very simple backup script. Creates a tar.gz archive from a folder,
# encrypts it using gpg and uploads it to a FTP server. Usage:
#
#   ftp-enc-backup.sh <SOURCE_DIR> <ENC_PASSWORD> <FTP_HOST> <FTP_USER> <FTP_PASSWORD>
#
if [ $# -ne 5 ]
then
    echo "Usage:"
    echo "  $0 <SOURCE_DIR> <ENC_PASSWORD> <FTP_HOST> <FTP_USER> <FTP_PASSWORD>"
    exit
fi

SOURCE=$1
PASSWORD=$2
FTP_HOST=$3
FTP_USER=$4
FTP_PASS=$5
SOURCE_BN=$(basename "$SOURCE")
CUR_DIR=$(pwd)
TARGET="$SOURCE_BN.bak.tar.gz"
ENCRYPTED="$TARGET.gpg"

# create archive
cd $SOURCE
cd ..
tar -zcf "$CUR_DIR/$TARGET" $SOURCE_BN/*
cd $CUR_DIR
# encrpyt archive
gpg --symmetric --passphrase $PASSWORD --batch $TARGET
# remove unencrypted
rm $TARGET
# upload encrypted archive
ln -s $ENCRYPTED "backup.tar.gz.pgp.new"
ftp -pn <<EOF
open $FTP_HOST
user $FTP_USER $FTP_PASS
send "backup.tar.gz.pgp.new"
delete "backup.tar.gz.pgp"
rename "backup.tar.gz.pgp.new" "backup.tar.gz.pgp"
quit
EOF
# remove encrypted
rm "backup.tar.gz.pgp.new"
rm $ENCRYPTED
