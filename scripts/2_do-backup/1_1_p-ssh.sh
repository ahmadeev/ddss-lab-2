ssh-keygen -t ed25519 -C "backups"

ssh-copy-id -i ~/.ssh/id_ed25519.pub "$REMOTE"

ssh "$REMOTE" "echo 'hello'"