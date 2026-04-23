echo "[1/2] Проверка доступности сервера"
psql -p "$PORT" -d "$DB" -c "SELECT now();"

echo "[2/2] Проверка таблиц"
psql -p "$PORT" -d "$DB" << EOF
SELECT * FROM table1 ORDER BY id DESC LIMIT 10;
SELECT * FROM table2 ORDER BY id DESC LIMIT 10;
SELECT * FROM table3 ORDER BY id DESC LIMIT 10;
EOF
