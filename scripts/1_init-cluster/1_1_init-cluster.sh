mkdir -p $PGDATA
mkdir -p $PGWAL

initdb \
    --pgdata=$PGDATA \
    --encoding=$PGENCODING \
    --locale=$PGLOCALE \
    --username=$PGUSERNAME \
    --waldir=$PGWAL