#!/usr/bin/env bash

SAMPLE_DATA="true"
MAGE_VERSION="1.9.1.0"
DATA_VERSION="1.9.0.0"

# Update Repositories
sudo apt-get update

# Determine Ubuntu Version
. /etc/lsb-release

# Decide on package to install for `add-apt-repository` command
#
# USE_COMMON=1 when using a distribution over 12.04
# USE_COMMON=0 when using a distribution at 12.04 or older
USE_COMMON=$(echo "$DISTRIB_RELEASE > 12.04" | bc)

if [ "$USE_COMMON" -eq "1" ];
then
    sudo apt-get install -y software-properties-common
else
    sudo apt-get install -y python-software-properties
fi

# Add Ansible Repository & Install Ansible
sudo add-apt-repository -y ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible

# Setup Ansible for Local Use and Run
cp /vagrant/ansible/inventories/dev /etc/ansible/hosts -f
chmod 666 /etc/ansible/hosts
cat /vagrant/ansible/files/authorized_keys >> /home/vagrant/.ssh/authorized_keys
sudo ansible-playbook /vagrant/ansible/playbook.yml -e hostname=$1 --connection=local



# Magento
# --------------------
# http://www.magentocommerce.com/wiki/1_-_installation_and_configuration/installing_magento_via_shell_ssh

# Download and extract
if [[ ! -f "/vagrant/index.php" ]]; then
  echo "Download Magento files"
  cd /vagrant
  wget http://www.magentocommerce.com/downloads/assets/${MAGE_VERSION}/magento-${MAGE_VERSION}.tar.gz
  sudo tar -zxvf magento-${MAGE_VERSION}.tar.gz
  sudo shopt -s dotglob
  sudo mv magento/* ./
  sudo mv magento/.htaccess ./
  sudo chmod -R o+w media var
  sudo chmod o+w app/etc
  # Clean up downloaded file and extracted dir
  sudo rm -rf magento*
fi

    echo "chmod folders"
    cd /vagrant
    sudo chmod -R 777 ./var
    sudo chmod -R 777 ./media
    sudo chmod -R 777 ./app/etc
    sudo chmod -R 755 ./var/session
    sudo chmod -R 755 /var/lib/php5/sessions

# Run installer
if [ ! -f "/vagrant/app/etc/local.xml" ]; then
  echo "run magento installer"
  cd /vagrant


sudo php -f install.php -- \
--license_agreement_accepted "yes" \
--locale "en_US" \
--timezone "Europe/Zurich" \
--default_currency "CHF" \
--db_host "localhost" \
--db_name "magento" \
--db_user "magentouser" \
--db_pass "magentopass" \
--url "http://magento.dev/" \
--use_rewrites "yes" \
--use_secure "no" \
--secure_base_url "" \
--use_secure_admin "no" \
--admin_firstname "Philippe" \
--admin_lastname "Savary" \
--admin_email "philippe.savary@liip.ch" \
--admin_username "admin" \
--admin_password "l11padmin" \
--skip_url_validation "yes" \
--session_save_path "/tmp" #this line doesen't work

  /usr/bin/php -f shell/indexer.php reindexall
fi




# Sample Data
if [[ $SAMPLE_DATA == "true" ]]; then
  echo "install sample data"
  cd /vagrant

  if [[ ! -f "/vagrant/magento-sample-data-${DATA_VERSION}.tar.gz" ]]; then
    # Only download sample data if we need to
    wget http://www.magentocommerce.com/downloads/assets/${DATA_VERSION}/magento-sample-data-${DATA_VERSION}.tar.gz
  fi
  echo "unzip sample data"

  sudo tar -zxvf magento-sample-data-${DATA_VERSION}.tar.gz
  sudo cp -R magento-sample-data-${DATA_VERSION}/media/* media/
  sudo cp -R magento-sample-data-${DATA_VERSION}/skin/*  skin/
  echo "drop database"
  sudo mysql -u root --execute="drop database magento;" #todo make a variable out of the databasename
  echo "create database"
  sudo mysql -u root --execute="create database magento;" #todo make a variable out of the databasename
  echo "upload database"
  sudo mysql -u root  magento < magento-sample-data-${DATA_VERSION}/magento_sample_data_for_${DATA_VERSION}.sql; #todo make a variable out of the databasename
  exit
  sudo rm -rf magento-sample-data-${DATA_VERSION}
  echo "finished installing sample data"
fi



# Install n98-magerun
# --------------------
if [ ! -f "/usr/local/bin/n98-magerun.phar" ]; then
    echo "install n98-magerun"
    cd /vagrant
    wget https://raw.github.com/netz98/n98-magerun/master/n98-magerun.phar
    chmod +x ./n98-magerun.phar
    sudo mv ./n98-magerun.phar /usr/local/bin/
    echo "done install n98-magerun"

fi

echo "Changing cache directory for magento in local.xml"
cd /vagrant
sudo php -f ./ansible/files/custom_install.php
echo "done changin cache directory"


echo ""
echo "###############"
echo ""
echo "Make sure to have '192.168.33.99  magento.dev' in your hosts file or install vagrant-hostmaster:"
echo ""
echo "$ vagrant gem install vagrant-hostmaster"
echo ""
echo "###############"
echo ""