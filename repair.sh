echo "creating memory directory..."
mkdir -p /dev/shm/storj
rm /dev/shm/storj/*
echo "dumping database..."
ls -sh $1
sqlite3 $1 < dump.sql
cat /dev/shm/storj/dump_all.sql | grep -v TRANSACTION | grep -v ROLLBACK | grep -v COMMIT > /dev/shm/storj/dump_all_notrans.sql
echo "making backup..."
mv $1 $1.bak
echo "repairing..."
sqlite3 /dev/shm/storj/database.db ".read /dev/shm/storj/dump_all_notrans.sql"
ls -sh /dev/shm/storj/database.db
echo "vacuuming..."
ls -sh /dev/shm/storj/database.db
sqlite3 /dev/shm/storj/database.db "$i" 'VACUUM;'
echo "moving back..."
mv /dev/shm/storj/database.db $1
ls -sh $1