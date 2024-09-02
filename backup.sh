#!/usr/bin/env bash

#0  */3  *  *  *  /mnt/DOOM/BACKUPS/backup.sh  /home/bob/  /mnt/DOOM/BACKUPS/bob/daily    56  |  tee  -a  /mnt/DOOM/BACKUPS/bob/log.txt
#0  0    *  *  4  /mnt/DOOM/BACKUPS/backup.sh  /home/bob/  /mnt/DOOM/BACKUPS/bob/weekly   4   |  tee  -a  /mnt/DOOM/BACKUPS/bob/log.txt
#0  0    1  *  *  /mnt/DOOM/BACKUPS/backup.sh  /home/bob/  /mnt/DOOM/BACKUPS/bob/monthly  12  |  tee  -a  /mnt/DOOM/BACKUPS/bob/log.txt

# A script to perform incremental backups using rsync

set -o errexit
set -o nounset
set -o pipefail


readonly KEEP="$3"
readonly SOURCE_DIR="$1"
readonly BACKUP_DIR="$2"
readonly DATETIME="$(date '+%Y-%m-%d_%H-%M-%S')"
readonly BACKUP_PATH="${BACKUP_DIR}/${DATETIME}"
readonly LATEST_LINK="$(dirname ${BACKUP_DIR})/latest"

mkdir -p "${BACKUP_DIR}"

rsync -avh --delete \
    "${SOURCE_DIR}/" \
    --link-dest "${LATEST_LINK}" \
    --exclude=".cache/" \
    --exclude="cache/" \
    --exclude="snap/" \
    "${BACKUP_PATH}"

rm -rf "${LATEST_LINK}"
ln -s "${BACKUP_PATH}" "${LATEST_LINK}"


COUNT=$(ls "${BACKUP_DIR}" | wc -l)

if [[ ${COUNT} -gt ${KEEP} ]]; then

  TRASH=$(ls "${BACKUP_DIR}" | sort -r | tail -n $(( ${COUNT} - ${KEEP} )) )

  for t in ${TRASH}; do
    rm -rf "${BACKUP_DIR}/${t}"
    echo "REMOVED: ${BACKUP_DIR}/${t}"
  done

fi

