# Drupal-dev
### A [PuPHPet](https://puphpet.com/) configuration to provision LAMP stack in [Vagrant](http://www.vagrantup.com/) with additional tools for [Dupal](https://www.drupal.org) development.

It allows to provision full stack virtual machine and install Drupal 7 and Drupal 8 using only 1 command - `vagrant up`.

Sometimes you just want to start working on a module or module-port and there
is no sandboxed environment that allows you to just start.
Download this and provision a virtual box - and you are ready to go!

## Installation
1. Install [Virtual Box](https://www.virtualbox.org/)
2. Install [Vagrant](http://www.vagrantup.com/)
3. Install [Vagrant Host Manager plugin](https://github.com/smdahlen/vagrant-hostmanager)<br/>
 	```
	vagrant plugin install vagrant-hostmanager
	```
4. Install [Vagrant Snapshot plugin](https://github.com/dergachev/vagrant-vbox-snapshot/)<br/>
	```
	vagrant plugin install vagrant-vbox-snapshot
	```
5. Some OSes require NFS server to be installed. OSX has NFS server inbuilt and running by default.
6. Download this project.
7. Navigate to project's directory and run<br/>
   ```vagrant-scripts/vagrant-rebuild.sh```
   
   
## What's in the box?
* [Ubuntu Precise x64] (http://box.puphpet.com/ubuntu-precise12042-x64-vbox43.box)
* git, vim, curl
* Apache 2
* PHP 5.4
* MySQL (credentials: admin/password)
* Composer
* XDebug
* APC
* Memcache
* Mail catcher
* Drupal 7 (credentials: admin/password)
* Drupal 8 (credentials: admin/password)

Configuration for this box is stored in file `/puphpet/config.yaml`.
Custom configuration for your project can be stored in `config.local.yaml`.

## What else is there?
* `app` directory for custom app developemnt.
* Support for custom PuPHPet configuration override in `config.app.yaml` and `config.local.yaml`.
* Vagrant snapshot support.
* [DCR](https://github.com/alexdesignworks/dcr) composer configuration to lint code.
* CLI debugging helper.
* PHPStorm 9 settings for Drupal and Symfony apps.<br/>
  Use File > Import Settings from within PHPStorm to apply these settings.
   
## FAQs
* *Can I shutdown my VM without loosing changes?*<br/>
  Yes. Nothing will be lost when you simply power off the VM with `vagrant halt`.  

* *What will happen to installed Drupal 7 and Drupal 8 sites after reboot of VM?*<br/>
  Nothing. They will be preserved. These sites are installed only on the first run.

* *Can this be used for development of real projects?*<br/>
  Definitely! Just make sure you configure `config.local.yaml` file to add specific details about your project.
  
## Working with snapshots
The main problem with any VM provisioniong is a time to bring the box to the "default" state -  a state when the VM is ready for you to start actual programming. Noramlly, you would rebuild your VM from the scratch wasting all that precious time to sit and wait until it is ready. At some point, you may even become afraid to experiment with your VM because you simply want to avoid the wait. Well, snpashots are here to help!

Consider the following workflow:

1. Provision brand new VM (25-30 minutes).
2. Import DB for `app`. (3 minutes to 3 hours).
3. Run pending DB updates.
4. Do actual work which may ruin your VM.
5. Rebuild from the scratch and re-run steps 1-3. This will make you wait for your environment full rebuild which is highly inefficient.

Snapshots allow to run steps 1-3 only once and then switch between snapshots:

1. Provision brand new VM (25-30 minutes) with `vagrant-scripts/vagrant-rebuild.sh`.
2. Import DB for `app`. (3 minutes to 3 hours).
3. Run pending DB updates.
4. Do actual work which may ruin your VM.
5. Run `vagrant-scripts/vagrant-snapshot-restore.sh` to restore the VM to the state of step 4 in **15 seconds instead of 30 minutes**!
6. Use `vagrant snapshot list` to check created snapshots.

## DCR (Drupal Code Review)
Bring all your code review dependencies with one command!

1. [Read DCR documentation](https://github.com/alexdesignworks/dcr)
2. In vagrant VM, chage directory to your project and run `composer install`.
3. Once everything is installed, run ```vendor/bin/dcr install && ~/.profile```.
4. Run `dcr` to check your custom modules code!

## Enabling CLI debug
1. In PHPStorm:
   * Setup directory mapping.
   * Setup server: set name to `app.local` and IDE key to `PHPSTORM`.
2. SSH into vagrant box with `vagrant ssh` and run<br/>
	```
	. /home/vagrant/sctipts/cli-debug-enable.sh app.local
	```

3. Click on the Phone icon and set a breakpoint in your script.
4. Run your php script and observe how PHPStorm will suspend it at the breakpoint.


## Useful links
* [Drupal Organised](http://www.drupalorganised.com)
* [DCR](https://github.com/alexdesignworks/dcr)
* [CircleCI module testing](https://github.com/alexdesignworks/drupal_circleci_template)
* [Strict commit messages](https://github.com/alexdesignworks/git-hooks)
* [drupal_helpers](https://github.com/nicksantamaria/drupal_helpers) module - missing Drupal helpers.
* [site_test](https://www.drupal.org/project/site_test) module - start testing Drupal sites today!
* [drupal\_file_downloader](https://github.com/alexdesignworks/drupal_file_downloader) module - download files from remote providers (useful when running updates).
