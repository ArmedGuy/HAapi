express = require 'express'
mongoose = require 'mongoose'
Agenda = require 'agenda'
Agendash = require 'agendash'
debug = (require 'debug')('haapi:bootstrap')

port = 3000
dburl = 'mongodb://localhost:27017/haapi'

app = express()

load = (module, params...) ->
	debug "loading #{module}"
	m = require module
	m params...

module.exports =
	bootstrap: (callback) ->
		mongoose.connect dburl
		# on successful connection, load models and define
		mongoose.connection.on 'open', (err) ->
			db = mongoose
			# load model definitions
			load './models/index', db

			# load agenda and agendash for task management
			agenda = new Agenda
			agenda.database dburl
			# register agendash
			app.use '/agendash', Agendash(agenda)

			# load job definitions
			load './jobs/index', agenda, db

			# give access to database on request
			app.use (req, res, next) ->
				req.db = db
				next()

			# load routes, done on db conn because app.use for db needs to be before routes
			app.use(load './routes/index', app)

			# run callback, telling caller we have bootstrapped
			callback()
	run: () ->
		app.listen port



