MOD="${0%/*}"
BLK="/dev/block/mmcblk1p2"
DIR="/data/data/com.termux"
TMP="$DIR/files/usr/tmp"
RUN="$DIR/files/usr/var/run"

if [ -b "$BLK" ] && [ -d "$DIR" ]; then
  OWN="$(stat -c "%u:%g" "$DIR")"
  PERM="$(stat -c "%a" "$DIR")"

  e2fsck.static -p "$BLK"
  case "$?" in
    0|1)
      # No errors / Errors corrected
      ;;
    2)
      # Reboot is required
      stop
      reboot
      ;;
    *)
      # Manual repair required
      stop
      touch "$MOD/disable"
      reboot
      ;;
  esac
  mount -o "noatime,commit=900" "$BLK" "$DIR"

  rm -rf "$TMP"
  mkdir -p "$TMP"
  mount -t "tmpfs" "tmpfs" "$TMP"
  rm -rf "$RUN"
  mkdir -p "$RUN"
  mount -t "tmpfs" "tmpfs" "$RUN"

  chown -R "$OWN" "$DIR"
  chmod "$PERM" "$DIR"
fi
