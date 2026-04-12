BACKUP_PATH="$(ssh "$REMOTE" "ls -1dt $REMOTE_PATH/backup_* | head -n 1")"

echo "[1/6] Остановка PostgreSQL из $NEW_PGDATA"
pg_ctl stop -D "$NEW_PGDATA" -m fast || true

echo
echo "[2/6] Подготовка директорий кластера"
rm -rf "$NEW_PGDATA"
rm -rf "$TABLESPACE_1" "$TABLESPACE_2" "$TABLESPACE_3"

mkdir -p "$NEW_PGDATA"
mkdir -p "$TABLESPACE_1" "$TABLESPACE_2" "$TABLESPACE_3"

echo
echo "[3/6] Восстановление из бэкапа"
rsync -a "$REMOTE:$BACKUP_PATH/pgdata/" "$NEW_PGDATA/"
rsync -a "$REMOTE:$BACKUP_PATH/$(basename "$TABLESPACE_1")/" "$TABLESPACE_1/"
rsync -a "$REMOTE:$BACKUP_PATH/$(basename "$TABLESPACE_2")/" "$TABLESPACE_2/"
rsync -a "$REMOTE:$BACKUP_PATH/$(basename "$TABLESPACE_3")/" "$TABLESPACE_3/"

echo
echo "[4/6] Корректировка конфигурации под новый PGDATA"
for f in "$NEW_PGDATA/postgresql.conf" "$NEW_PGDATA/postgresql.auto.conf"; do
  [ -f "$f" ] || continue
  sed -i "s|$OLD_PGDATA|$NEW_PGDATA|g" "$f"
done

echo
echo "[5/6] Запуск PostgreSQL из $NEW_PGDATA"
pg_ctl start -D "$NEW_PGDATA"

echo
echo "[6/6] Проверка работы"
pg_ctl status -D "$NEW_PGDATA"

echo "--- Проверка времени:"
psql -p "$PORT" -d "$DBNAME" -c "SELECT now();"

echo
echo "--- Проверка табличных пространств:"
psql -p "$PORT" -d "$DBNAME" -c "\db+"

echo
echo "--- Проверка таблиц:"
psql -p "$PORT" -d "$DBNAME" -c "\dt+"

echo
echo "Восстановление завершено."
echo "Новый PGDATA: $NEW_PGDATA"