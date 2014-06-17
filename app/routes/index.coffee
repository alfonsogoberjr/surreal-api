app = require('express')

module.exports = (app, passport, express, logger) ->
	require('./user')(app, passport, express, logger)