express = require 'express'
router = new express.Router

router.get '/', (req, res) ->
	ProxyServer = req.db.model 'ProxyServer'
	ProxyServer.find (err, servers) ->
		return if err?
		res.json servers
router.get '/:address', (req, res) ->
	address = req.params.address
	ProxyServer = req.db.model 'ProxyServer'
	ProxyServer.find address: address, (err, servers) ->
		return if err?
		res.json servers

router.post '/', (req, res) ->
	ProxyServer = req.db.model 'ProxyServer'
	pr = new ProxyServer req.body
	pr.save (err, server) ->
		return if err?
		res.status 200
			.json server
module.exports = router
