mkdir -p /dev/shm/storj && \
rm -f /dev/shm/storj/* && \
cp -av data/storage/*.db* /dev/shm/storj/ && \
for i in /dev/shm/storj/*.db; do
  echo "Vacuum: $i"
  sqlite3 "$i" 'VACUUM;'
done && \
mv -v /dev/shm/storj data/storage/database-temp && \
sync -f data/storage/database-temp && \
rm -fv data/storage/*.db* && \
mv -v data/storage/database-temp/* data/storage/ && \
rmdir data/storage/database-temp
date
