module VagrantPlugins
	module MoonshineUpdater
		module Action
			class RemoveHosts
				include MoonshineUpdater

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