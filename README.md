# Vagrant::Ghost

[![Gem Version](https://badge.fury.io/rb/vagrant-ghost.svg)](http://badge.fury.io/rb/vagrant-ghost)

This plugin adds an entry to your /etc/hosts file on the host system.
 
On **up**, **resume** and **reload** commands, it tries to add the information, if its not already in your hosts file. If it needs to be added, you will be asked for an administrator password, since it uses sudo to edit the file.
 
On **halt**, **destroy**, and **suspend** those entries will be removed again.
 
## Installation
 
    $ vagrant plugin install vagrant-ghost
 
Uninstall it with:
 
    $ vagrant plugin uninstall vagrant-ghost
 
## Usage
 
At the moment, the only things you need, are the hostname and a :private_network network with a fixed ip.
 
    config.vm.network :private_network, ip: "192.168.3.10"
    config.vm.hostname = "www.testing.de"
    config.ghost.hosts = ["alias.testing.de", "alias2.somedomain.com"]
 
This ip and the hostname will be used for the entry in the /etc/hosts file.

Additional aliases can be added by creating an `/aliases` file at the root of the Vagrant machine installation with one host alias per line. This file will be re-imported whenever Vagrant Ghost updates the hostsfile.
 
##  Changelog

### 0.2.0
* Use `ghost.config.hosts` to set static hosts while pulling dynamic ones from an `/aliases` file
* Update documentation

### 0.1.3
* Consoldiate `/config/hosts` and `/aliases` to just `/**/aliases`

### 0.1.2
* Make the CLI command scan a local hosts setup files (`/config/hosts` and `/aliases`) to rebuild the hosts map

### 0.1.1
* Update the CLI to a "primary" command
* Make sure help doesn't try to fire a host update

### 0.1.0
* Initial release

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

This is a fork of [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater).
```