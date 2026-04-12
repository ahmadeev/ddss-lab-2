pg_ctl stop -D "$PGDATA" || true

rm -rf "$PGDATA"
rm -rf "$TABLESPACE_1"
rm -rf "$TABLESPACE_2"
rm -rf "$TABLESPACE_3"

mkdir -p "$PGDATA"
mkdir -p "$TABLESPACE_1"
mkdir -p "$TABLESPACE_2"
mkdir -p "$TABLESPACE_3"

BACKUP_NAME=$(ls -1dt ~/pg_backups/backup_* | head -n 1)

rsync -a "$BACKUP_NAME"/pgdata/ "$PGDATA"/
rsync -a "$BACKUP_NAME"/$(basename "$TABLESPACE_1")/ "$TABLESPACE_1"/
rsync -a "$BACKUP_NAME"/$(basename "$TABLESPACE_2")/ "$TABLESPACE_2"/
rsync -a "$BACKUP_NAME"/$(basename "$TABLESPACE_3")/ "$TABLESPACE_3"/

for link in "$PGDATA"/pg_tblspc/*; do 
  [ -L "$link" ] || continue 
  target=$(readlink "$link") 
  new_target=$(echo "$target" | sed 's|/var/db/postgres3/|/var/db/postgres4/|') 
  rm "$link" 
  ln -s "$new_target" "$link" 
done

pg_ctl start -D "$PGDATA"