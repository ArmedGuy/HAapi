debug = (require 'debug')('haapi:jobs:config')
ssh2 = require 'node-ssh'
module.exports = (agenda, db) ->
	ProxyServer = db.model 'ProxyServer'
	agenda.define 'write haproxy config to server', (job, done) ->
		id = job.attrs.data
		ProxyServer.findOne address: id, (err, server) ->
			return if err?
			return if not server.activeConfig?
			debug "attempting to access server #{server}"
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
