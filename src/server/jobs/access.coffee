ssh2 = require 'node-ssh'
module.exports = (agenda, db) ->
	ProxyServer = db.model 'ProxyServer'
	agenda.define 'check all server access', (job, done) ->
		ProxyServer.find (err, servers) ->
			return if err?
			for server in servers
				do (server) ->
					agenda.schedule 'in 1 minute', 'check server access', server.id
			done()
	agenda.define 'check server access', (job, done) ->
		id = job.attrs.data
		ProxyServer.findById id, (err, server) ->
			return if err?
			ssh = new ssh2
			ssh.connect
				host: server.address
				port: server.port
				username: server.user
				privateKey: server.privateKey
			.then () ->
				server.status.canConnect = true
				server.save()
				ssh.end()
				done()
			.catch (err) ->
				server.status.canConnect = false
				server.save()
				ssh.end()
				done()
	agenda.on 'ready', () ->
		agenda.every '10 minutes', 'check all server access'
