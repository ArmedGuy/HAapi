models = [
	'haapi'
]
module.exports = (db) ->
	for model in models
		do (model) ->
			m = require "./#{model}"
			# pass common names to model def function
			m db, db.Schema, db.Schema.ObjectId
