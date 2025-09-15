# btrfs-clicker

This is yet another small set of scripts for _creating and pruning BTRFS snapshots_. I use it on my immutable Linux operating system (ATOMIC Fedora). It can be run by ordinary users, as long as they are allowed `sudo btrfs`. It does not require access to any files outside of `$HOME`.

The scripts maintain sets of hourly, daily, weekly and monthly snapshots. The scripts are idempotent, meaning that thet can be called any number of times without causing uninteded effects.

# Usage
`btrfs-click` creates a new set of snapshots:
* Create an _hourly_ snapshot, if none has been made earlier this hour
* Create a _daily_ snapshot, if none has been made earlier today
* Create a _weekly_ snapshot, if none has been made earlier this week
* Create a _monhtly_ snapshot, if none has been made earlier this month

`btrfs-clean` removes old snapshots:
* Remove _hourly_ snapshots older than 4 hours
* Remove _daily_ snapshots older than 7 days
* Remove _weekly_ snapshots older than 4 weeks
* Remove _monthly_ snapshots older than 3 months

# Installation
* Both scripts are on the `$PATH` and executable.
* Command `/usr/bin/btrfs` is available.
* User has `sudo` rights for `/usr/bin/btrfs`.
* Subvolume `$HOME/.snapshots` is available.

# Configuration
`btrfs-click.sh` script:
* Change the _snapshot path_ from `$HOME/.snapshots` to something else.

`btrfs-clean.sh` script:
* Change the _snapshot path_ from `$HOME/.snapshots` to something else.
* Change the _expiration date_ for hourly, daily, weekly and monthly snapshots.

