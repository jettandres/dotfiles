function system_backup
  echo "System backup initiated."
  echo "Invoking rsync..."

  sudo rsync -aAXHvSx -e ssh --delete --numeric-ids --info=progress2 --exclude-from rsync_backup.filter / jettandres@192.168.254.107:/media/lenovo-x230/backups/$(date +%Y-%m-%d:_%T)/
  echo "System backup complete!"
end
