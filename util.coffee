env = process.env.NODE_ENV or "development"
global = require("./config/config")
config = require("./config/config")[env]

# var crypto = require('crypto');
url = require("url")
logger = require("./config/logger")

#below from http://stackoverflow.com/questions/13063350/node-js-incoming-request-sourceip
exports.getClientIp = (req) ->
  ipAddress = null
  forwardedIpsStr = req.headers["x-forwarded-for"]
  ipAddress = forwardedIpsStr[0]  if forwardedIpsStr
  ipAddress = req.connection.remoteAddress  unless ipAddress
  ipAddress


# For CORS cross-domain requests
# TODO: Better solution will require examining OPTIONS.
exports.allowCrossDomain = (req, res, next) ->
  res.header "Access-Control-Allow-Origin", global.corsAllowOrigin
  
  # res.header('Access-Control-Allow-Credentials',true);
  res.header "Access-Control-Allow-Methods", "GET,PUT,POST,DELETE,OPTIONS"
  res.header "Access-Control-Allow-Headers", "Content-Type, Authorization, Content-Length, X-Requested-With"
  if "OPTIONS" is req.method
    res.send 200
  else
    next()
  return

exports.auth = (req, res, next) ->
  unless req.isAuthenticated()
    res.send 401
  else
    next()
  return

exports.dateFromId = (mongo_id) ->
  mongo_id.getTimestamp()

exports.die = (message) ->
  console.log "die: " + message
  process.exit 1
  return


#
#If you want some encryption, here is some code that'll work for you.
#
#exports.encrypt = function(message,key) {
#  if(!message) return ""
#  var cipher = crypto.createCipher('aes-256-cbc',key);
#  var result = cipher.update(message,'utf8','hex');
#  result += cipher.final('hex');   
#  return result;
#}
#
#exports.decrypt = function(message,key) {
#  if(!message) return ""
#  var decipher = crypto.createDecipher('aes-256-cbc',key);
#  var decrypted = decipher.update(message,'hex','utf8');
#  decrypted += decipher.final('utf8');
#  return decrypted;
#}
#
exports.basePath = (rootUrl, p) ->
  return ""  unless p
  p = p.replace(rootUrl, "")
  components = url.parse(p).pathname.split("/")
  i = 0

  while i < components.length
    return components[i]  unless components[i].length is 0
    i++
  ""


#Generate a token
exports.newToken = ->
  jwt = require("jwt-simple")
  rbytes = require("rbytes")
  r = rbytes.randomBytes(16).toHex()
  token = jwt.encode(r, global.tokenConfigSecret)
  token

exports.handleControllerError = (moduleName, httpStatus, err, httpErrMessage, res) ->
  logger.error moduleName + ": " + err
  res.json httpStatus, httpErrMessage
  return
