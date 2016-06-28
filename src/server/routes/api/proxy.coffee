express = require 'express'
router = new express.Router
# Basic CRUD
router.get '/', (req, res) ->
	ProxyServer = req.db.model 'ProxyServer'
	ProxyServer.find (err, servers) ->
		return if err?
		res.json servers
router.get '/:address', (req, res) ->
	address = req.params.address
	ProxyServer = req.db.model 'ProxyServer'
	ProxyServer.findOne address: address, (err, server) ->
		return if err?
		res.json server

router.post '/', (req, res) ->
	ProxyServer = req.db.model 'ProxyServer'
	pr = new ProxyServer req.body
	pr.save (err, server) ->
		return if err?
		res.status 200
			.json server

router.put '/:address', (req, res) ->
	address = req.params.address
	ProxyServer = req.db.model 'ProxyServer'
	ProxyServer.findOneAndUpdate address: address, req.body, (err, server) ->
		return if err?
		res.status 200
			.json server
router.delete '/:address', (req, res) ->
	address = req.params.address
	ProxyServer = req.db.model 'ProxyServer'
	ProxyServer.remove address: address, (err) ->
		return if err?
		res.status 200
			.json
				status: "OK"

# Control functions

router.post '/:address/check', (req, res) ->
	address = req.params.address
	ProxyServer = req.db.model 'ProxyServer'
	ProxyServer.findOne address: address, (err, server) ->
		return if err?
		req.agenda.schedule 'in 10 seconds', 'check server access', address
		res.status 200
			.json
				status: "OK"
module.exports = router
