require "vagrant-moonshineupdater/Action/UpdateHosts"
require "vagrant-moonshineupdater/Action/CacheHosts"
require "vagrant-moonshineupdater/Action/RemoveHosts"

module VagrantPlugins
	module MoonshineUpdater
		class Plugin < Vagrant.plugin('2')
			name 'MoonshineUpdater'
			description <<-DESC
				This plugin manages your hosts files internally and externally
			DESC

			config(:moonshineupdater) do
				require_relative 'config'
				Config
			end

			action_hook(:moonshineupdater, :machine_action_up) do |hook|
				hook.append(Action::UpdateHosts)
			end

			action_hook(:moonshineupdater, :machine_action_halt) do |hook|
				hook.append(Action::RemoveHosts)
			end

			action_hook(:moonshineupdater, :machine_action_suspend) do |hook|
				hook.append(Action::RemoveHosts)
			end

			action_hook(:moonshineupdater, :machine_action_destroy) do |hook|
				hook.prepend(Action::CacheHosts)
			end

			action_hook(:moonshineupdater, :machine_action_destroy) do |hook|
				hook.append(Action::RemoveHosts)
			end

			action_hook(:moonshineupdater, :machine_action_reload) do |hook|
				hook.prepend(Action::RemoveHosts)
				hook.append(Action::UpdateHosts)
			end

			action_hook(:moonshineupdater, :machine_action_resume) do |hook|
				hook.append(Action::UpdateHosts)
			end

			command(:moonshineupdater, primary: false) do
				require_relative 'command'
				Command
			end
		end
	end
end