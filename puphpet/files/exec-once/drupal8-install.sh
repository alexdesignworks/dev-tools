#!/bin/bash
#
# Installs Drupal 8 using drush.

#
# Variables below correspond to values in PuPHPet's config.yml.
#

# User who has write access to install Drupal.
USER=vagrant

# Group of your Apache Server.
GROUP=www-data

# Drupal install directory.
DRUPAL_DIR=/var/www/drupal8

# Drupal URL.
DRUPAL_URI=drupal8.local

#Drupal site name.
DRUPAL_NAME="Drupal 8"

# MySQL DB name and credentials.
DRUPAL_MYSQL_USER=admin
DRUPAL_MYSQL_PASSWORD=password
DRUPAL_MYSQL_DB=drupal8

# Drupal administrator's credentials.
DRUPAL_USER_NAME=admin
DRUPAL_USER_PASSWORD=password
DRUPAL_USER_MAIL=admin@example.com

# Drupal release to use: drupal, drupal-7.x etc.
DRUPAL_RELEASE=drupal-8.0.x

# Start installation.
echo '****** DRUPAL 8 INSTALLATION ******'

# Modify user to make sure that there will be no permission issues.
sudo usermod -a -G ${GROUP} ${USER}

# Remove any contents from docroot, if exist.
sudo rm -Rf ${DRUPAL_DIR}/*

# Create Drupal docroot and assign permissions.
sudo sh -c "mkdir -p ${DRUPAL_DIR}; chmod -f 775 ${DRUPAL_DIR}; chown -f ${USER}:${GROUP} ${DRUPAL_DIR}; chmod g+s ${DRUPAL_DIR}"

# Download Drupal using drush.
drush dl --destination="`dirname ${DRUPAL_DIR}`" --drupal-project-rename="`basename ${DRUPAL_DIR}`" ${DRUPAL_RELEASE} -y

# Install Drupal.
drush --root=${DRUPAL_DIR} --uri=http://${DRUPAL_URI} site-install standard --db-url=mysql://${DRUPAL_MYSQL_USER}:${DRUPAL_MYSQL_PASSWORD}@localhost/${DRUPAL_MYSQL_DB} --account-name=${DRUPAL_USER_NAME} --account-pass=${DRUPAL_USER_PASSWORD} --account-mail=${DRUPAL_USER_MAIL} --site-mail=${DRUPAL_USER_MAIL} --site-name=${DRUPAL_NAME} -y install_configure_form.update_status_module='array(FALSE,FALSE)'

# Create sites/default/files directory.
mkdir ${DRUPAL_DIR}/sites/default/files

# Change permissions for files directory.
sudo sh -c "chown -R ${WEB_USER}:${WEB_GROUP} ${DRUPAL_DIR}/sites/default/files; chmod g+s ${DRUPAL_DIR}/sites/default/files"
 
# Show information about installed Drupal.
drush status --root=${DRUPAL_DIR}