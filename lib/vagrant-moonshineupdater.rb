require "vagrant-moonshineupdater/version"
require "vagrant-moonshineupdater/plugin"

module VagrantPlugins
  module MoonshineUpdater
  	def self.source_root
  	  @source_root ||= Pathname.new(File.expand_path('../../', __FILE__))
  	end
  end
end
