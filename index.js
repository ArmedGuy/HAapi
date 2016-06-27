var server = require('./lib/server/index.js');
server.bootstrap(function() {
	server.run(process.env.PORT ? process.env.PORT : 3000);
});
