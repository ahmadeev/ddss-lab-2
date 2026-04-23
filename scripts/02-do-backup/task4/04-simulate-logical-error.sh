echo "[1/3] Данные до ошибки"
psql -p "$PORT" -d "$DB" << EOF
SELECT * FROM table1 ORDER BY id DESC LIMIT 5;
SELECT * FROM table2 ORDER BY id DESC LIMIT 5;
SELECT * FROM table3 ORDER BY id DESC LIMIT 5;
EOF

echo "[2/3] Логическое повреждение"
psql -p "$PORT" -d "$DB" << EOF
INSERT INTO table1 (name) VALUES ("МУСОР_1"), ("МУСОР_2");
EOF

echo "[3/3] Показываем данные после ошибки"
psql -p "$PORT" -d "$DB" << EOF
SELECT * FROM table1 ORDER BY id DESC LIMIT 10;
EOF