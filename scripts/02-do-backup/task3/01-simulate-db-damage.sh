echo "[1/5] Проверка статуса кластера"
pg_ctl status -D "$OLD_PGDATA" || true

echo
echo "[2/5] Проверка доступности данных в БД"
psql -p "$PORT" -d "$DBNAME" -c "SELECT now();"

echo
echo "[3/5] Остановка PostgreSQL"
pg_ctl stop -D "$OLD_PGDATA" -m fast

echo
echo "[4/5] Удаляем директорию $PGDATA"
mv "$OLD_PGDATA" "$HOME/lxy26_broken"

echo
echo "[5/5] Проверка последствий сбоя"
echo "--- Попытка узнать статус:"
pg_ctl status -D "$OLD_PGDATA" || true

echo
echo "--- Попытка запустить PostgreSQL из старого PGDATA:"
pg_ctl start -D "$OLD_PGDATA" || true

echo
echo "--- Попытка подключиться к БД:"
psql -p "$PORT" -d "$DBNAME" -c "SELECT 1;" || true

echo
echo "Симуляция завершена"