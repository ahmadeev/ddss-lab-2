RESTORE_TIME="$(cat restore_time.txt)"

echo "[1/7] Остановка PostgreSQL"
pg_ctl -D "$PGDATA" stop -m fast || true

echo "[2/7] Удаление старого каталога восстановления"
rm -rf "$PGDATA"
mkdir -p "$PGDATA"

echo "[3/7] Восстановление из базовой копии"
rsync -a "$BASEBACKUP_DIR/" "$PGDATA/"

echo "[4/7] Создание recovery signal"
touch "$PGDATA/recovery.signal"

echo "[5/7] Настройка восстановления"
cat >> "$PGDATA/postgresql.auto.conf" << EOF

restore_command = 'cp $ARCHIVE_DIR/%f %p'
recovery_target_time = '$RESTORE_TIME'
recovery_target_action = 'promote'
EOF

echo "[6/7] Запуск восстановленного кластера"
pg_ctl -D "$PGDATA" start

echo "[7/7] Проверка режима работы"
psql -p "$PORT" -d "$DB" -c "SELECT pg_is_in_recovery();"
echo "Восстановление запущено до времени: $RESTORE_TIME"