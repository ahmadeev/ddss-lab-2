echo "[1/4] ОСтановка PostgreSQL"
pg_ctl -D "$PGDATA" stop -m fast

echo "[2/4] Обновление базовой копии"
rm -rf "$BASEBACKUP_DIR"
rsync -a "$PGDATA/" "$BASEBACKUP_DIR/"

echo "[3/4] Запуск PostgreSQL"
pg_ctl -D "$PGDATA" start

echo "[4/4] Базовая копия готова: $BASEBACKUP_DIR"