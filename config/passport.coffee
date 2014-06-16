mongoose = require("mongoose")
LocalStrategy = require("passport-local").Strategy
BearerStrategy = require("passport-http-bearer").Strategy
User = mongoose.model("User")
util = require("../util")
module.exports = (passport, config, logger) ->
  passport.serializeUser (user, done) ->
    done null, user.id
    return

  passport.deserializeUser (id, done) ->
    User.findById id, (err, user) ->
      done err, user
      return

    return

  
  #passport.authenticate('local') in the routes.js file uses this strategy..
  #send email, password as POST parameters
  passport.use new LocalStrategy(
    usernameField: "email"
    passwordField: "password"
  , (email, password, done) ->
    User.isValidUserPassword email, password, (err, doc) ->
      return done(err.error)  if err
      
      #save a token for the user
      if doc
        doc.token = util.newToken()
        doc.save (err, doc) ->
          done err  if err
          done null, doc

      return

    return
  )
  
  #passport.authenticate('bearer') in the routes.js file uses this strategy.
  passport.use new BearerStrategy((token, done) ->
    
    # logger.debug("BearerStrategy looking for token: " + token);
    User.findOne
      token: token
    , (err, user) ->
      return done(err)  if err
      
      # logger.debug('BearerStrategy: user not found');
      return done(null, false)  unless user
      
      # logger.debug('BearerStrategy: user found:' + JSON.stringify(user));
      done null, user,
        scope: "all"


    return
  )
  return
