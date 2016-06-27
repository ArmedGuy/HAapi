module.exports = (db, Schema, ObjectId) ->
	UseBackend = new Schema
		backend:
			type: String
		ifs:
			type: String
	db.model 'UseBackend', UseBackend

	ACL = new Schema
		name:
			type: String
		cond:
			type: String
	db.model 'ACL', ACL

	Frontend = new Schema
		bind:
			type: String
			default: '*:80'
		mode:
			type: String
			default: 'http'
		options: [String]
		acl: [ACL]
		use: [UseBackend]
		default_use: UseBackend
	db.model 'Frontend', Frontend

	BackendServer = new Schema
		name:
			type: String
		path:
			type: String
		options:
			type: String
	db.model 'BackendServer', BackendServer

	Backend = new Schema
		name:
			type: String
		balance:
			type: String
			default: 'roundrobin'
		mode:
			type: String
		servers: [BackendServer]
	db.model 'Backend', Backend

	Config = new Schema
		name:
			type: String
		frontends: [Frontend]
		backends: [Backend]
	db.model 'Config', Config

	ProxyServer = new Schema
		adress:
			type: String
			default: 'server.example.com'
			unique: true
		port:
			type: Number
			default: 22
		user:
			type: String
			default: 'haapi'
		privateKey:
			type: String
			default: '/home/haapi/.ssh/id_rsa'
		activeConfig: Config
	db.model 'ProxyServer', ProxyServer
