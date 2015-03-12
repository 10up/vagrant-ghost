require "vagrant-ghost/version"
require "vagrant-ghost/plugin"

module VagrantPlugins
  module Ghost
  	def self.source_root
  	  @source_root ||= Pathname.new(File.expand_path('../../', __FILE__))
  	end
  end
end
