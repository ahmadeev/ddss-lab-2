PGDATA="$HOME/lxy26"
TABLESPACE_1="$HOME/vja47"
TABLESPACE_2="$HOME/vso93"
TABLESPACE_3="$HOME/znb64"
REMOTE="postgres4@pg116"
REMOTE_DIR="~/pg_backups"

DATE=$(date +%F_%H-%M-%S)
BACKUP_DIR="$REMOTE_DIR/backup_$DATE"

######## 1. ОСТАНОВКА ########

echo "[1/6] Stop PostgreSQL"
pg_ctl stop -D "$PGDATA" -m fast

######## 2. СОЗДАНИЕ ДИРЕКТОРИИ НА РЕЗЕРВНОМ УЗЛЕ ########

echo "[2/6] Create backup directory on remote"
ssh $REMOTE "mkdir -p $BACKUP_DIR"

######## 3. КОПИРОВАНИЕ PGDATA ########

echo "[3/6] Backup PGDATA"
rsync -a "$PGDATA/" "$REMOTE:$BACKUP_DIR/pgdata/"

######## 4. КОПИРОВАНИЕ ТАБЛИЧНЫХ ПРОСТРАНСТВ ########

echo "[4/6] Backup tablespaces"

rsync -a "$TABLESPACE_1/" "$REMOTE:$BACKUP_DIR/$(basename "$TABLESPACE_1")/"
rsync -a "$TABLESPACE_2/" "$REMOTE:$BACKUP_DIR/$(basename "$TABLESPACE_2")/"
rsync -a "$TABLESPACE_3/" "$REMOTE:$BACKUP_DIR/$(basename "$TABLESPACE_3")/"

######## 5. ЗАПУСК СУБД ########

echo "[5/6] Start PostgreSQL"
pg_ctl start -D "$PGDATA"

######## 6. РОТАЦИЯ (14 КОПИЙ) ########

echo "[6/6] Remove old backups (keep last 14)"

ssh "$REMOTE" "
cd $REMOTE_DIR
ls -1dt backup_* 2>/dev/null | tail -n +15 | xargs -r rm -rf
"

echo "Backup completed successfully"