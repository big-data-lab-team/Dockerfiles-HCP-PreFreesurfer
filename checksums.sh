#!/bin/bash

set -u
set -e

function die {
    echo -e "ERROR: $*:">&2
    # will exit the script since the error flag is set
    exit 1
}

if [ $# != 1 ]
then
    die "Usage: $0 <subject_folder> \n Input the subject folder name."
fi

SUBJECT_FOLDER=$1
QSUB_FILE=".science.out.*"

echo "Hello from checksum: I'm in $PWD, subject folder is $1, here is the output of ls -a:"
ls -a
echo "and here is the result of the find command:"
find ${SUBJECT_FOLDER} -type f

echo "###########################################"
echo "############ Checksum of docker image #####"
echo "###########################################"

(ls ${QSUB_FILE} && grep "Digest: sha256:" ${QSUB_FILE}) || die "Cannot find sha256 digest of docker image"

echo "*******************************************"
echo "************ Checksum of files ************"
echo "*******************************************"

find ${SUBJECT_FOLDER} -type f | sort | xargs md5sum

