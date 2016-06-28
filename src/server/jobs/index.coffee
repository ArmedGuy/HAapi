jobs = [
	'access'
]
module.exports = (agenda, db) ->
	for job in jobs
		do (job) ->
			m = require "./#{job}"
			m agenda, db

