module VagrantPlugins
	module Ghost
		class Command < Vagrant.plugin('2', :command)
			include Ghost

			def self.synopsis
				'manages hosts files internally and externally'
			end

			def execute
				options = {}
				options[:provider] = @env.default_provider

				opts = OptionParser.new do |o|
					o.banner = 'Usage: vagrant ghost'
					o.separator ''

					o.on('-h', '--help', 'Print this help') do
						safe_puts(opts.help)
						return
					end

					o.on('--provider provider', String, 'Update machines with the specific provider.') do |provider|
						options[:provider] = provider
					end
				end

				argv = parse_options(opts)
				return if !argv

				@ui = @env.ui

				with_target_vms(argv, reverse: true) do |machine|
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
