# Magento Vagrant (powered by Ansible)

This project tries to get you up and running with your new Magento project in no time. It creates a VM which has it's webfolder on your local machine. This way you can develop your code from your local machine and run the whole application in a dedicated VM which is also accessible through your browser and ssh.

You can add this VM to an existing Magento project of yours or let the Vagrantfile install Magento from scratch if you want. You can even decide if you want sample data installed on your Magento instance.

# Setup

## Prerequisites

You need to have installed Vagrant and Vagrant Host Manager on your local machine:

Installing Vagrant:
Go to http://docs.vagrantup.com/v2/installation/

### Installing Vagrant Host Manager:
Cli command:
<b>vagrant plugin install vagrant-hostmanager</b>
Project site:
https://github.com/smdahlen/vagrant-hostmanager

## Installing Magerant on your empty or existing project folder
Simply copy the folder "ansible" and the file "Vagrantfile" to your root of your project.

## Starting your Vagrant machine:

Open your commandline. Navigate to the root of your project and type <b>"vagrant up"</b>. After the provisioning is done, you can access your Vagrant machine via commandline by simply typing <b>"vagrant ssh"</b>.

## Default configuration:

IP: dhcp 
URL: magento.dev

Magento admin:

URL: magento.dev/admin

User: admin

Password: l11padmin

## Connect to database

You can connect to the database via your local machine:

### Default config:

URL: magento.dev (or whatever you've configured)
User: magentouser
Pass: magentopass

SSH User: vagrant
SSH Pass: vagrant

![Screenshot 2015-05-22 10.32.37](https://gitlab.liip.ch/uploads/philippe.savary/magerant/93ce31fab7/Screenshot_2015-05-22_10.32.37.png)

## Configuring your Project

### Disclaimer:

It is not nescessary to change the configuration until you have several Vagrant VM's running at the same time with the same configuration. I recommend not to change the configurations for the first provision of the Vagrantmachine.

But if you are convinced you can handle it, there are a few configurations you have to take a look at:

### Vagrantfile

Check the variable "hostname", this will be the url your project will be accessible via http

### ansible/vars/mysql.yml

Here you can set DB name, user and password.

### ansible/init.sh

Define if you want to install <b>sample Data</b> or not: SAMPLE_DATA="false"
Define the magento version to install if not already present: MAGE_VERSION="1.9.1.0"
Define the version of the sample data to install: DATA_VERSION="1.9.0.0"

Please check the lines after "sudo php -f install.php". Here, you have to set passwords and URL for your Magento project. Please make sure, the database config is the same as in "mysql.yml". Also, you can set a admin user and password.

