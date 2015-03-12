module VagrantPlugins
	module MoonshineUpdater
		class Command < Vagrant.plugin('2', :command)
			include MoonshineUpdater

			def execute
				options = {}
				opts = OptionParser.new do |o|
					o.banner = 'Usage: vagrant hostmanager [vm-name]'
					o.separator ''

					o.on('--provider provider', String, 'Update machines with the specific provider.') do |provider|
						options[:provider] = provider
					end
				end

				argv = parse_options(opts)
				options[:provider] ||= @env.default_provider

				@ui = @env.ui

				with_target_vms(argv, options) do |machine|
					@machine = machine

					# Always remove hosts to make sure old entries don't stick around
					removeHostEntries
					# Add all hosts again if the vm is up
					addHostEntries if is_running?
				end
				0
			rescue Exception => e
				@env.ui.error "Something went wrong!"
				@env.ui.error "  #{e.message}"
				@env.ui.error "  #{e.backtrace.inspect}"
				1
			end

			protected

			def is_running?(machine=nil)
				machine ||= @machine

				case machine.provider_name.to_sym
				when :hyperv, :virtualbox
					return :running == machine.state.id
				end

				false
			end
		end
	end
end
