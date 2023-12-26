function system_backup
  echo "initializing full system backup"
  sudo rsync -aAxv -e ssh --filter "merge rsync_backup.filter" --numeric-ids / jettandres@192.168.254.102:/media/lenovo-x230/backups/$(date +%Y-%m-%d:_%T)/
  echo "done!"
end
