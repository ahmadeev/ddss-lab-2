cat >> $PGDATA/postgresql.conf << EOF

listen_addresses = '*'
port = 9839

max_connections = 15 # 10 + 5
shared_buffers = 512MB
temp_buffers = 64MB
work_mem = 32MB
checkpoint_timeout = 15min
effective_cache_size = 1536MB
fsync = on
commit_delay = 5000 # 5ms

logging_collector = true
log_destination = 'csvlog'
log_min_messages = 'WARNING'
log_checkpoints = on
log_connections = on

log_directory = 'log'
log_filename = 'postgresql-%Y-%m-%d_%H%M%S'
log_rotation_age = 1d
log_rotation_size = 100MB
log_file_mode = 0640

EOF

# tail -n 25 $PGDATA/postgresql.conf