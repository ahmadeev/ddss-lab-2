cat > $PGDATA/pg_hba.conf << EOF

# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   goodyellowdisk  s367839                                 peer map=quickfix    # необходимый фикс
local   all             all                                     peer
host    all             all             0.0.0.0/0               ident
host    all             all             ::/0                    ident

EOF

# cat $PGDATA/pg_hba.conf