debug = (require 'debug')('routes')
express = require 'express'
router = new express.Router

routes = [
	'app'
	'api/server'
	'api/frontend'
	'api/backend'
	'api/acl'
]
modules.export = () ->
	for route in routes
		do (route) ->
			debug "Registering #{route}"
			router.use "/#{route}", require "./#{route}" unless route is ""
	return router
