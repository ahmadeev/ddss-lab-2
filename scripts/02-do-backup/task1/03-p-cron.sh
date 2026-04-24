touch backup-script.sh

cat >> backup-script.sh << EOF
# script
EOF

(crontab -l 2>/dev/null; echo "0 3 * * * ~/backup-script.sh") | crontab -

# crontab -l