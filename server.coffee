env         = process.env.NODE_ENV or "development"

express     = require("express")
logger      = require("./config/logger")
global      = require("./config/config")
config      = require("./config/config")[env]
fs          = require("fs")
mongoose    = require("mongoose")
util        = require("./util")
passport    = require("passport")
colors      = require('colors')
u           = require("util")
moment      = require('moment')
bodyParser  = require('body-parser')

app         = express()

logger.info "environment: " + env

#connect mongoose
unless mongoose.connection.readyState
  logger.info "Connecting to Mongo...".magenta
  mongoose.connect config.db, (err) ->
    throw err  if err
    logger.info "Connected to Mongo at: ".magenta + config.db.green
    return


# boostrap models
models_path = __dirname + "/app/models"
fs.readdirSync(models_path).forEach (file) ->
  logger.info "loading model from: " + models_path + "/" + file
  require models_path + "/" + file  if ~file.indexOf(".coffee")
  return

require("./config/passport") passport, config, logger

#general app configuration
app.use util.allowCrossDomain
app.use passport.initialize()
app.use bodyParser()
app.set 'port', config.port
app.set 'version', require('./package').version
app.set 'description', require('./package').description

logger.info "allowing origin: " + JSON.stringify(global.corsAllowOrigin)
require("./app/routes") app, passport, express, logger
server = require("http").createServer(app)
require("./config/socket") server, logger
server.listen config.port, ->
  now = new Date()
  timestamp = moment().format('D MMM H:mm:ss')
  logger.warn "WARNING: I'm using the default token secret, which is 'abc123'. YOU DON'T WANT THAT.\n\n\n" if process.env.SURREAL_CONFIG_SECRET is "abc123"
  logger.info "%s - %s v%s ("+"%s".blue+") port "+"%d".red, timestamp.yellow, app.get('description').underline, app.get('version'), app.get('env').cyan, app.get('port')
  return

module.exports = app
