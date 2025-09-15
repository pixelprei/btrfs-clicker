#!/bin/bash

prefix="$HOME/.snapshots"

hour="$(date +"%H")"
minute="$(date +"%M")"
month="$(date +"%m")"
year="$(date +"%Y")"
day="$(date +"%d")"
week="$(date +"%V")"

date="$year$month$day"

# create subvolume $1, if missing
function create() {
  if [ ! -d "$1" ]; then
    /usr/bin/sudo /usr/bin/btrfs subvolume create "$1"
  fi
}

# create snapshot with pattern $1, name $2, and type $3
function click() {
  if compgen -G "$prefix/$3/$1" > /dev/null; then
    echo "No $3 snapshot made: snapshot already present."
  else
    create "$prefix"
    create "$prefix/$3"

    /usr/bin/sudo /usr/bin/btrfs subvolume snapshot /var/home/rob "$prefix/$3/$2"
  fi
}

# check availability of command $1
function check() {
  if [ ! -f "$1" ]; then
    echo "Missing $1"
    exit
  fi
}

check "/usr/bin/sudo"
check "/usr/bin/btrfs"

click "$date-$hour??-$USER"        "$date-$hour$minute-$USER"        "hourly"
click "$date-????-$USER"           "$date-$hour$minute-$USER"        "daily"
click "????????-????-W$week-$USER" "$date-$hour$minute-W$week-$USER" "weekly"
click "$year$month??-????-$USER"   "$date-$hour$minute-$USER"        "monthly"

