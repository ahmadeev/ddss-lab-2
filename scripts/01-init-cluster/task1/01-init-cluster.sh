mkdir -p $PGDATA

initdb \
    --pgdata=$PGDATA \
    --encoding=$PGENCODING \
    --locale=$PGLOCALE \
    --username=$PGUSERNAME \
