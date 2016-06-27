express = require 'express'
router = new express.Router

router.get '/test', (req, res) ->
	res.send("Swag")

module.exports = router
