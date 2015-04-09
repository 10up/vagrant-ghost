require "vagrant"

module VagrantPlugins
	module Ghost
		class Config < Vagrant.plugin("2", :config)
			attr_accessor :hosts
			attr_accessor :id
		end
	end
end