debug = (require 'debug')('haapi:jobs:access')
ssh2 = require 'node-ssh'
module.exports = (agenda, db) ->
	ProxyServer = db.model 'ProxyServer'
	agenda.define 'check all server access', (job, done) ->
		ProxyServer.find (err, servers) ->
			return if err?
			for server in servers
				do (server) ->
					agenda.schedule 'in 10 seconds', 'check server access', server.address
			done()
	agenda.define 'check server access', (job, done) ->
		id = job.attrs.data
		ProxyServer.findOne address: id, (err, server) ->
			return if err?
			debug "checking acccess to server #{server}"
			ssh = new ssh2
			ssh.connect
				host: server.address
				port: server.port
				username: server.user
				privateKey: server.privateKey
			.then () ->
				debug "ssh successful"
				server.status.canConnect = true
				server.save()
				ssh.execCommand "echo '' | tee -a #{server.configFile}"
					.then (result) ->
						debug "trying access to config file, results: #{result.stdout} --- #{result.stderr}"
						server.status.canAccessConfig = not result.stderr.includes "Permission denied"
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
