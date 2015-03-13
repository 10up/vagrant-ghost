require "vagrant-ghost/Action/UpdateHosts"
require "vagrant-ghost/Action/CacheHosts"
require "vagrant-ghost/Action/RemoveHosts"

module VagrantPlugins
	module Ghost
		class Plugin < Vagrant.plugin('2')
			name 'Ghost'
			description <<-DESC
				This plugin manages your hosts files internally and externally
			DESC

			config(:ghost) do
				require_relative 'config'
				Config
			end

			action_hook(:ghost, :machine_action_up) do |hook|
				hook.append(Action::UpdateHosts)
			end

			action_hook(:ghost, :machine_action_halt) do |hook|
				hook.append(Action::RemoveHosts)
			end

			action_hook(:ghost, :machine_action_suspend) do |hook|
				hook.append(Action::RemoveHosts)
			end

			action_hook(:ghost, :machine_action_destroy) do |hook|
				hook.prepend(Action::CacheHosts)
			end

			action_hook(:ghost, :machine_action_destroy) do |hook|
				hook.append(Action::RemoveHosts)
			end

			action_hook(:ghost, :machine_action_reload) do |hook|
				hook.prepend(Action::RemoveHosts)
				hook.append(Action::UpdateHosts)
			end

			action_hook(:ghost, :machine_action_resume) do |hook|
				hook.append(Action::UpdateHosts)
			end

			command(:ghost, primary: true) do
				require_relative 'command'
				Command
			end
		end
	end
end