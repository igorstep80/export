#!/bin/bash
LOG_FILE=logfile.txt
exec > >(while read -r line; do printf '%s %s\n' "$(date --rfc-3339=seconds)" "$line" | tee -a $LOG_FILE; done)
exec 2> >(while read -r line; do printf '%s %s\n' "$(date --rfc-3339=seconds)" "$line" | tee -a $LOG_FILE; done >&2)
find /mnt -maxdepth 5 \( -iname "*.db" ! -iname "revocations.db" \) -print0 -exec sqlite3 '{}' 'PRAGMA integrity_check;' ';'
