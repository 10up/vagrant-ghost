require "vagrant"

module VagrantPlugins
	module MoonshineUpdater
		class Config < Vagrant.plugin("2", :config)
			attr_accessor :aliases
			attr_accessor :id
		end
	end
end