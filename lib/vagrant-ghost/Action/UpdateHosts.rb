require_relative "../Ghost"
module VagrantPlugins
	module Ghost
		module Action
			class UpdateHosts
				include Ghost


				def initialize(app, env)
					@app = app
					@machine = env[:machine]
					@ui = env[:ui]
				end

				def call(env)
					@ui.info "Checking for host entries"
					@app.call(env)
					addHostEntries()
				end

			end
		end
	end
end