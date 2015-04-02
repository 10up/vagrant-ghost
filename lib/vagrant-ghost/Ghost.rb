module VagrantPlugins
	module Ghost
		module Ghost
			@@hosts_path = Vagrant::Util::Platform.windows? ? File.expand_path('system32/drivers/etc/hosts', ENV['windir']) : '/etc/hosts'

			def getIps
				ips = []
				@machine.config.vm.networks.each do |network|
					key, options = network[0], network[1]
					ip = options[:ip] if key == :private_network
					ips.push(ip) if ip
				end

				begin
					network = @machine.provider.driver.read_guest_ip
					if network['ip']
						ips.push( network['ip'] ) unless ips.include? network['ip']
					end
				rescue
				end

				return ips
			end

			def getHostnames
				hostnames = Array(@machine.config.vm.hostname)

				# Regenerate hostsfile
				paths = Dir[File.join( 'config', '**', 'hosts' )]
				hosts = paths.map do |path|
					lines = File.readlines(path).map(&:chomp)
					lines.grep(/\A[^#]/)
				end.flatten.uniq

				# Pull in managed aliases
				local = Dir[File.join( '**', 'hostsalias' )]
				local_hosts = local.map do |path|
					lines = File.readlines(path).map(&:chomp)
					lines.grep(/\A[^#]/)
				end.flatten.uniq

				# Merge our lists together
				aliases = ( hosts << local_hosts ).flatten!

				# Concat with the local hostname
				hostnames.concat( aliases )

				# Update the achine configuration
				if @machine.config.ghost.aliases
					@machine.config.ghost.aliases = aliases
				end

				return hostnames
			end

			def addHostEntries
				ips = getIps
				hostnames = getHostnames
				file = File.open(@@hosts_path, "rb")
				hostsContents = file.read
				uuid = @machine.id
				name = @machine.name
				entries = []
				ips.each do |ip|
					hostEntries = getHostEntries(ip, hostnames, name, uuid)
					hostEntries.each do |hostEntry|
						escapedEntry = Regexp.quote(hostEntry)
						if !hostsContents.match(/#{escapedEntry}/)
							@ui.info "adding to (#@@hosts_path) : #{hostEntry}"
							entries.push(hostEntry)
						end
					end
				end
				addToHosts(entries)
			end

			def cacheHostEntries
				@machine.config.ghost.id = @machine.id
			end

			def removeHostEntries
				if !@machine.id and !@machine.config.ghost.id
					@ui.warn "No machine id, nothing removed from #@@hosts_path"
					return
				end
				file = File.open(@@hosts_path, "rb")
				hostsContents = file.read
				uuid = @machine.id || @machine.config.ghost.id
				hashedId = Digest::MD5.hexdigest(uuid)
				if hostsContents.match(/#{hashedId}/)
						removeFromHosts
				end
			end

			def host_entry(ip, hostnames, name, uuid = self.uuid)
				%Q(#{ip}	#{hostnames.join(' ')}	#{signature(name, uuid)})
			end

			def getHostEntries(ip, hostnames, name, uuid = self.uuid)
				entries = []
				hostnames.each do |hostname|
					entries.push(%Q(#{ip}	#{hostname}	#{signature(name, uuid)}))
				end
				return entries
			end

			def addToHosts(entries)
				return if entries.length == 0
				content = entries.join("\n").strip
				if !File.writable?(@@hosts_path)
					sudo(%Q(sh -c 'echo "#{content}" >> #@@hosts_path'))
				else
					content = "\n" + content
					hostsFile = File.open(@@hosts_path, "a")
					hostsFile.write(content)
					hostsFile.close()
				end
			end

			def removeFromHosts(options = {})
				uuid = @machine.id || @machine.config.ghost.id
				hashedId = Digest::MD5.hexdigest(uuid)
				if !File.writable?(@@hosts_path)
					sudo(%Q(sed -i -e '/#{hashedId}/ d' #@@hosts_path))
				else
					hosts = ""
					File.open(@@hosts_path).each do |line|
						hosts << line unless line.include?(hashedId)
					end
					hostsFile = File.open(@@hosts_path, "w")
					hostsFile.write(hosts)
					hostsFile.close()
				end
			end



			def signature(name, uuid = self.uuid)
				hashedId = Digest::MD5.hexdigest(uuid)
				%Q(# VAGRANT: #{hashedId} (#{name}) / #{uuid})
			end

			def sudo(command)
				return if !command
				if Vagrant::Util::Platform.windows?
					`#{command}`
				else
					`sudo #{command}`
				end
			end
		end
	end
end
