module VagrantPlugins
	module MoonshineUpdater
		module Action
			class CacheHosts
				include MoonshineUpdater

				def initialize(app, env)
					@app = app
					@machine = env[:machine]
				end

				def call(env)
					cacheHostEntries
					@app.call(env)
				end

			end
		end
	end
end