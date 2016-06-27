debug = (require 'debug')('haapi:routes')
express = require 'express'
router = new express.Router

routes = [
	'app'
#	'api/server'
#	'api/frontend'
#	'api/backend'
#	'api/acl'
]
module.exports = () ->
	for route in routes
		do (route) ->
			debug "Registering #{route}"
			router.use "/#{route}", require "./#{route}" unless route is ""
	return router
