#!/bin/bash
#
# Rebuild vagrant VM from local box and run Drupal updates.
#
# - destroys existing VM
# - provisions new VM
# - stores baseline snapshot for unmodified DB before updates run.
# - runs cache clear and DB updates
# - stores v1 snapshot for modified DB after updates ran.

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

# Check for Vagrantfile to make sure we are in the right path.
if [ ! -e ./Vagrantfile ] ; then
  echo "This can only be run from the same path as your Vagrantfile"
  echo "  ie: cd ~/Projects/vagrant/ && ./vagrant-scripts/vagrant-rebuild.sh"
  exit 1
fi

# If we are in the right path, destroy everything.
echo "Destroying VM in 5 seconds"
countdown "00:00:05"
vagrant destroy -f

# Remove any ssh keys as it may fail during next authentication.
rm -rf puphpet/files/dot/ssh/*

# On MacOSX sometimes virtualbox doesn't start properly on reboot
# Mavericks seems to have changed startup commands or something
# so if we are on MacOSX (Darwin) and /dev/vboxnetctl doesn't exist
# we need to restart virtualbox.
if [ "`uname -a | grep Darwin`" ] && [ ! -e /dev/vboxnetctl ] ; then
  echo "Restarting VirtualBox to reload kernel module"
  sudo /Library/StartupItems/VirtualBox/VirtualBox restart
fi

echo "Provisioning new VM"
vagrant up

take_snapshot "baseline"

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

# Try to take a snapshot.
take_snapshot "v1"

# SSH into vagrant box.
vagrant ssh
