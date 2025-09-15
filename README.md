# btrfs-clicker

This is yet another small set of scripts for _creating and pruning BTRFS snapshots_. I use it on my immutable Linux operating system (ATOMIC Fedora). It can be run by non-priviledged users, as long as they are allowed `sudo btrfs`. The scripts do not require access to any files outside of `$HOME`.

The scripts maintain sets of hourly, daily, weekly and monthly snapshots. The scripts are _idempotent_, meaning that they can be called any number of times without causing uninteded effects (see usage).

# Usage
`btrfs-click` creates a new set of snapshots:
* Create an _hourly_ snapshot, if none has been made earlier this hour
* Create a _daily_ snapshot, if none has been made earlier today
* Create a _weekly_ snapshot, if none has been made earlier this week
* Create a _monthly_ snapshot, if none has been made earlier this month

`btrfs-clean` removes old snapshots:
* Remove _hourly_ snapshots older than 4 hours
* Remove _daily_ snapshots older than 7 days
* Remove _weekly_ snapshots older than 4 weeks
* Remove _monthly_ snapshots older than 3 months

Using & listing snapshots can be done using the `btrfs` command. Consider making an alias for the following command that shows a list of snapshots:
```
sudo btrfs subvolume list -ts --sort=path $HOME/.snapshots/
```

# Prerequisites
* Both scripts are on the `$PATH` and executable. A good place is `/usr/local/bin/`.
* Commands `/usr/bin/btrfs` and `/usr/bin/sudo` are available.
* User has `sudo` rights for `btrfs`. You can do this by creating a group `user` and adding this line to `/etc/sudoers`: `%user   ALL=(ALL) NOPASSWD: /usr/bin/btrfs`
* Subvolume `$HOME/.snapshots` is available. Create it using `sudo btrfs subvolume create $HOME/.snapshots`.

# Configuration
To configure the `btrfs-click.sh` script:
* Change the _snapshot path_ from `$HOME/.snapshots` to something else.

To configure the `btrfs-clean.sh` script:
* Change the _snapshot path_ from `$HOME/.snapshots` to something else.
* Change the _expiration date_ for hourly, daily, weekly and monthly snapshots. This can be described in textual representation as described [here](https://www.gnu.org/software/coreutils/manual/html_node/Relative-items-in-date-strings.html#Relative-items-in-date-strings-1).

# Inspiration
This script is inspired by [snapper](http://snapper.io/). Although a lot more advanced, it requires [layering](https://coreos.github.io/rpm-ostree/layering/) which I want to avoid whenever possible. Another nice solution is [btrsnap](https://github.com/phdenzel/btrsnap). A bash script as well, but too advanced for my taste. More importantly, I run into issues on my immutable OS because the entire script must be run using `sudo`. Many other solutions exist, but I didn't try them.

