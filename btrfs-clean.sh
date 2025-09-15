#!/bin/bash

# this script purges snapshots that have gone past their expiration dates

# --- CONFIGURATION STARTS HERE -----------------------------------------

# expiration limits, change according to requirements
HOUR_LIMIT="4 hours"
DAY_LIMIT="4 days"
WEEK_LIMIT="4 weeks"
MONTH_LIMIT="4 months"

# snapshot directory base path
SUBVOLS="$HOME/.snapshots"

# snapshot directory paths
HOUR_SUBVOL="hourly"
DAY_SUBVOL="daily"
WEEK_SUBVOL="weekly"
MONTH_SUBVOL="monthly"
YEAR_SUBVOL="yearly"

# --- CONFIGURATION ENDS HERE -------------------------------------------

# return the creation date for subvolume with uuid $1
# change so that it returns EPOCH and path separated by space
function get_subvol_creation_date() {
  /usr/bin/sudo /usr/bin/btrfs subvolume show -u "$1" $SUBVOLS | \
    grep 'Creation time' | \
    sed -r 's/^\s*Creation time:\s*([0-9]{4}-[0-9]{2}-[0-9]{2}) ([0-9]{2}:[0-9]{2}:[0-9]{2}).*$/\1 \2.000/'
}

# check subvolume $1 and removve all snapshots older than $2 (Epoch format)
function get_subvol_uuids() {
  # get all hourly snapshots
  LINES=$(/usr/bin/sudo /usr/bin/btrfs subvolume list -o -u "$1")

  # iterate through the hourly snapshots
  while IFS= read -r line; do
      # get uuid and date (seconds since epoch)
      # make this better
      UUID=$(echo "$line" | sed -r 's/^.*uuid ([a-zA-Z0-9\-]*).*$/\1/')
      PTH=$(echo "$line" | sed -r 's/^.*path (.*)$/\1/')
      EPOCH=$(date --date="$(get_subvol_creation_date "$UUID")" +"%s")

      if [ $EPOCH \> $2 ];
      then
         echo "fresh: $PTH"
      else
        echo "stale: $PTH"
      fi    
    done <<< "$LINES"
}

echo "$(get_subvol_uuids "$SUBVOLS/$HOUR_SUBVOL/" $(date --date="$(date -d $"$HOUR_LIMIT ago")" +"%s"))"
echo "$(get_subvol_uuids "$SUBVOLS/$DAY_SUBVOL/" $(date --date="$(date -d "$DAY_LIMIT ago")" +"%s"))"
echo "$(get_subvol_uuids "$SUBVOLS/$WEEK_SUBVOL/" $(date --date="$(date -d "$WEEK_LIMIT ago")" +"%s"))"
echo "$(get_subvol_uuids "$SUBVOLS/$MONTH_SUBVOL/" $(date --date="$(date -d "$MONTH_LIMIT ago")" +"%s"))"

