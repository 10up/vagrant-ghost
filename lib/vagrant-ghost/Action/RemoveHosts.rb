module VagrantPlugins
	module Ghost
		module Action
			class RemoveHosts
				include Ghost

				def initialize(app, env)
					@app = app
					@machine = env[:machine]
					@ui = env[:ui]
				end

				def call(env)
					@ui.info "Removing hosts"
					removeHostEntries
					@app.call(env)
				end

			end
		end
	end
end