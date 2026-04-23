echo "[1/4] Текущее время на сервере"
psql -p "$PORT" -d "$DB" -At -c "SELECT now();"

echo "[2/4] Добавление новых строк данных"
psql -p "$PORT" -d "$DB" << EOF
INSERT INTO table1 (name) SELECT '[До_сбоя] Имя ' || g FROM generate_series(101, 103) g;
INSERT INTO table2 (value) SELECT g * 10 FROM generate_series(101, 103) g;
INSERT INTO table3 (info) SELECT '[До_сбоя] Инфо ' || g FROM generate_series(101, 103) g;
EOF

echo "[3/4] Фиксация времени после изменений"
RESTORE_TIME=$(psql -p "$PORT" -d "$DB" -At -c "SELECT now();")
echo "$RESTORE_TIME" | tee restore_time.txt

echo "[4/4] Время до сбоя"
echo "restore_time = $RESTORE_TIME"