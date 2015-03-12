# Moonshine Hostupdater

This is a fork of [vagrant-hostsupdater](/cogitatio/vagrant-hostsupdater). For now, it is only for use in development.

To test/use this plugin:

```sh
cd /path/to/moonshine/hostupdater
sudo gem install bundler -v '1.7.13'
bundle

```

This will install all the dependencies for this package and enable you to run vagrant with this plugin temporarily active.

After you've run the commands above, test with Vagrant by running vagrant commands prefixed with `bundle exec` from the `hostupdater` directory. For example:

```sh
bundle exec vagrant up
bundle exec vagrant halt
```

You can also manually trigger a host file update:

```
bundle exec vagrant moonshineupdater
```

If your VM is running, it will add the hosts to the hostfile. If it's not running, it will remove the hosts from the hostsfile.

To add a host to your hostsfile, you can specify hosts in your Vagrantfile:

```rb
config.vm.hostname = 'test.dev'
config.moonshineupdater.aliases = ['www.test.dev', 'foo.test.dev']
```