module VagrantPlugins
	module Ghost
		class Command < Vagrant.plugin('2', :command)
			include Ghost

			def self.synopsis
				'manages hosts files internally and externally'
			end

			def execute
				cmd, cmd_args, argv, options = parse_args
				cmd && cmd_args or return nil

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

			private

			def parse_args
				options = {}
				opts = OptionParser.new do |o|
					o.banner = 'Usage: vagrant ghost [vm-name]'
					o.separator ''

					o.on('-h', '--help', 'Print this help') do
						safe_puts(opts.help)
					end

					o.on('--provider provider', String, 'Update machines with the specific provider.') do |provider|
						options[:provider] = provider
					end
				end

				argv = split_main_and_subcommand(@argv.dup)
				exec_args, cmd, cmd_args = argv[0], argv[1], argv[2]

				# show help
				if !cmd || exec_args.any? { |a| a == '-h' || a == '--help' }
					safe_puts(opts.help)
					return nil
				end

				options[:provider] ||= @env.default_provider

				# remove extra "--" arge added by Vagrant
				cmd_args.delete_if { |a| a == '--' }

				return cmd, cmd_args, parse_options(opts), options
			end
		end
	end
end
