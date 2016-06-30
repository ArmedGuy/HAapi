build = require '../../utils/config-builder'
express = require 'express'
router = new express.Router
# Basic CRUD
router.get '/:name', (req, res) ->
	name = req.params.name
	Config = req.db.model 'Config'
	Config.findOne name: name, (err, config) ->
		return if err?
		res.json confi

router.post '/', (req, res) ->
	Config = req.db.model 'Config'
	data = req.body
	cfg = new Config data
	cfg.save (err, cfg) ->
		return if err?
		res.json cfg

router.put '/:name', (req, res) ->

router.get '/:name/build', (req, res) ->
	name = req.params.name
	Config = req.db.model 'Config'
	Config.findOne name: name, (err, config) ->
		return if err?
		res.send build(config)


module.exports = router
