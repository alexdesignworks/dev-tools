Drupal-dev
==========

What is it?
-----------
This is a [Vagrant](http://www.vagrantup.com/) configuration to provision LAMP stack with tools required for [Dupal](https://www.drupal.org) development.

What does it do?
----------------
Provisions full stack virtual machine and installs Drupal 7 and Drupal 8 using only 1 command - `vagrant up`.

Why?
----
Sometimes you just want to start working on a module or module-port and there
is no sandboxed environment that allows you to just start.
Download this and provision a virtual box - and you are ready to go!

Who is it for?
--------------
* Drupal devs
* Drupal starters

What's in the box?
------------------
* [Ubuntu Precise x64] (http://box.puphpet.com/ubuntu-precise12042-x64-vbox43.box)
* git, vim, curl
* Apache 2
* PHP 5.4
* MySQL
* Composer
* XDebug
* APC
* Memcache
* Mail catcher
* Drupal 7
* Drupal 8

Configuration for this box is stored in file `/puphpet/config.yaml`.

Credentials
-----------
* MySQL: admin/password
* Drupal 7/8: admin/password

What else is there?
-------------------
* PHPStorm_settings.jar - [PHPStorm](http://www.jetbrains.com/phpstorm/) settings file with Drupal code formatting standards.
  Use File > Import Settings from within PHPStorm to apply these settings.

Installation
------------
1. Install [Virtual Box](https://www.virtualbox.org/)
2. Install [Vagrant](http://www.vagrantup.com/)
3. Install [Vagrant Host Manager](https://github.com/smdahlen/vagrant-hostmanager)
4. Some OSes require NFS server to be installed. OSX has NFS server inbuilt and running by default.
5. Download this project and extract it into /www/drupal-dev directory, so that file Vagrantfile is accessible at /www/drupal-dev/Vagrantfile.
5. Navigate to /www/drupal-dev/ directory and run `vagrant up`.

FAQ
---
* Can I shutdown my VM without loosing changes?
  
  Yes. Nothing will be lost when you simply power off the VM.  

* What will happen to installed Drupal 7 and Drupal 8 sites after reboot of VM?
  
  Nothing. They will be preserved. These sites are installed only on the first run.

* Can this be used for development of real projects?
  
  Definitely! But you would need to additionally configure YAML file (manually or through PuPHPet website) to contain your project information, such as hostname, share paths etc.

Links
-----
* [Virtual Box](https://www.virtualbox.org/)
* [Vagrant](http://www.vagrantup.com/)
* [Vagrant Host Manager](https://github.com/smdahlen/vagrant-hostmanager)
* [PuPHPet](https://puphpet.com/)
* [PHPStorm](http://www.jetbrains.com/phpstorm/)
* [Drupal](https://www.drupal.org)

Productivity improvement for Mac!
---------------------------------
* [Tower](http://www.git-tower.com/)
* [Alfred](http://www.alfredapp.com/)
* [SizeUp](https://www.irradiatedsoftware.com/sizeup/)
* [Memory Clean](https://itunes.apple.com/au/app/memory-clean/id451444120?mt=12)
* [CodeKit](https://incident57.com/codekit/)
