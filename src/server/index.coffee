express = require 'express'
mongoose = require 'mongoose'
Agenda = require 'agenda'
Agendash = require 'agendash'

load = (module, param) ->
	m = require module
	m param

module.exports =
	settings:
		port: 3000
		dburl: 'mongodb://localhost:27017/haapi'

	bootstrap: (callback) ->
		app = express()
		mongoose.connect @.settings.dburl
		# on successful connection, load models and define
		mongoose.connection.on 'open', (err) ->
			db = mongoose.connection
			# load model definitions
			load './models/index', db

			# load agenda and agendash for task management
			agenda = new Agenda
			agenda.database @.settings.dburl
			# register agendash
			app.use '/agendash', Agendash(agenda)

			# load job definitions
			load './jobs/index', agenda

			# give access to database on request
			app.use (req, res, next) ->
				req.db = db
				next()

			# load routes, done on db conn because app.use for db needs to be before routes
			app.use(load './routes/index', app)

			# run callback, telling caller we have bootstrapped
			callback()
	run: () ->
		app.listen @.settings.port



