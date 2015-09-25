#!/bin/bash
#
# Restore vagrant to the latest snapshot.
#
# - reverts existing VM to the lastest snapshot
# - runs cache clear and DB updates
#
# Usage:
# vagrant-snapshot-restore.sh <snapshot name>
# Restores to the snapshot with specified name and run updates.
#
# vagrant-snapshot-restore.sh
# Restores to the latest snapshot and run updates.
#

# Drupal installation directory.
APP_DIR=/var/www/app
DRUSH=/usr/bin/drush

##
# Output Drupal major version.
#
function drupal_version() {
  DRUSH=/usr/bin/drush
  GREP=/bin/grep
  DRUPAL_VERSION=$($DRUSH status |$GREP -oP -m 1 'Drupal version\s*:\s*([0-9])'|$GREP -o [0-9])
  echo $DRUPAL_VERSION
}

##
# Drupal version-agnostic cache clear/rebuild.
#
function drush_cache_clear() {
  DRUSH=/usr/bin/drush
  DRUPAL_VERSION=$(drupal_version)
  if [ "$DRUPAL_VERSION" == "7" ]; then
    $($DRUSH cc all)
  else
    $($DRUSH cache-rebuild)
  fi
}

##
# Check if current directory is a Drupal installation.
#
function is_drupal() {
  # If 'sites' directory is present, current directory is most likely
  # a Drupal installation.
  DIR=sites
  return $([ -d "$DIR" ])
}

##
# Countdown timer.
#
# Usage example:
# countdown "00:00:05"
#
function countdown() {
  local OLD_IFS="${IFS}"
  IFS=":"
  local ARR=( $1 )
  local SECONDS=$((  (ARR[0] * 60 * 60) + (ARR[1] * 60) + ARR[2]  ))
  local START=$(date +%s)
  local END=$((START + SECONDS))
  local CUR=$START

  while [[ $CUR -lt $END ]]
  do
    CUR=$(date +%s)
    LEFT=$((END-CUR))

    printf "\r%02d:%02d:%02d" \
      $((LEFT/3600)) $(( (LEFT/60)%60)) $((LEFT%60))

    sleep 1
  done
  IFS="${OLD_IFS}"
  echo "        "
}

#
# Take snapshot, if vagrant-vbox-snapshot plugin installed.
#
function take_snapshot (){
  snapshot_name=$1
  if vagrant plugin list | grep -q vagrant-vbox-snapshot ; then
    vagrant snapshot take $snapshot_name
  fi
}

#
# Restore to specific snapshot.
#
function restore_snapshot (){
  if vagrant plugin list | grep -q vagrant-vbox-snapshot ; then
    vagrant snapshot go $1
  fi
}

#
# Restore to latest snapshot.
#
function restore_latest_snapshot (){
  if vagrant plugin list | grep -q vagrant-vbox-snapshot ; then
    vagrant snapshot back
  fi
}

# Check for Vagrantfile to make sure we are in the right path.
if [ ! -e ./Vagrantfile ] ; then
  echo "This can only be run from the same path as your Vagrantfile"
  echo "  ie: cd ~/Projects/vagrant/ && ./vagrant-scripts/vagrant-rebuild.sh"
  exit 1
fi

if ! vagrant plugin list | grep -q vagrant-vbox-snapshot ; then
  echo "Snapshot plugin (vagrant-vbox-snapshot) does not exist."
  exit 1
fi

# If we are in the right path, destroy everything.
echo "Reverting VM to the latest snapshot in 5 seconds"
countdown "00:00:05"

if [ ! -z "$1" ] ; then
  restore_snapshot "$1"
else
  restore_latest_snapshot
fi

# Run commands within vagrant box.
vagrant ssh --command=" \
  # Export local functions into remote shell context.
  $(typeset -f) && \
  # Change directory.
  cd $APP_DIR && \
  # Check if current directory is a Drupal installation.
  is_drupal && \
  # Clear cache (Drupal version-agnostic).
  drush_cache_clear && \
  # Run DB updates.
  $DRUSH updb -y \
"

# SSH into vagrant box.
vagrant ssh
