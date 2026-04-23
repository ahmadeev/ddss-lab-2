echo "[1/5] Создаём каталог архива WAL"
mkdir -p "$ARCHIVE_DIR"

echo "[2/5] Включаем архивирование в postgresql.auto.conf"
psql -p "$PORT" -d postgres << EOF
ALTER SYSTEM SET wal_level = 'replica';
ALTER SYSTEM SET archive_mode = 'on';
ALTER SYSTEM SET archive_command = 'test ! -f $ARCHIVE_DIR/%f && cp %p $ARCHIVE_DIR/%f';
EOF

echo "[3/5] Перезапускаем PostgreSQL"
pg_ctl -D "$PGDATA" restart

echo "[4/5] Проверяем параметры"
psql -p "$PORT" -d postgres -c "SHOW wal_level;"
psql -p "$PORT" -d postgres -c "SHOW archive_mode;"
psql -p "$PORT" -d postgres -c "SHOW archive_command;"

echo "[5/5] Принудительно переключаем WAL"
psql -p "$PORT" -d postgres -c "SELECT pg_switch_wal();"