build = require '../../utils/config-builder'
express = require 'express'
router = new express.Router
# Basic CRUD
router.get '/', (req, res) ->
	Config = req.db.model 'Config'
	Config.find (err, configs) ->
		return if err?
		res.json configs

router.get '/:name', (req, res) ->
	name = req.params.name
	Config = req.db.model 'Config'
	Config.findOne name: name, (err, config) ->
		return if err?
		res.json config

router.post '/', (req, res) ->
	Config = req.db.model 'Config'
	data = req.body
	cfg = new Config data
	cfg.save (err, cfg) ->
		return if err?
		res.json cfg

router.put '/:name', (req, res) ->
	name = req.params.name
	Config = req.db.model 'Config'
	Config.findOneAndUpdate name: name, req.body, (err, config) ->
		return if err?
		res.json config

router.get '/:name/build', (req, res) ->
	name = req.params.name
	Config = req.db.model 'Config'
	Config.findOne name: name, (err, config) ->
		return if err?
		res.send build(config)


module.exports = router
