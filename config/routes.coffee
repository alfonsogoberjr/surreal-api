mongoose = require("mongoose")
User = mongoose.model("User")
env = process.env.NODE_ENV or "development"
global = require("./config")
config = require("./config")[env]
templateController = require("../app/controllers/template")
module.exports = (app, passport, express, logger) ->
  
  #login using the credentials required in the passport.js config
  app.post "/login", passport.authenticate("local"), (req, res) ->
    req.logIn req.user, (err) ->
      if req.user
        success =
          success: "Logged in."
          token: req.user.token
          name: req.user.name

        
        # logger.debug("passport.authenticate returning: " + JSON.stringify(success));
        res.json success
      else
        logger.debug "req.Login error: " + JSON.stringify(err)
        res.send 401, err
      return

    return

  
  #invalidate (remove) the session token from the user account, preventing further logins
  app.get "/logout", passport.authenticate("bearer",
    session: false
  ), (req, res) ->
    User.logoutUserWithToken req.user.token, (err) ->
      res.send 401, err  if err
      req.logout()
      res.send 200, "Have a great day!"
      return

    return

  
  #check to see if a user is logged in, i.e. their account contains a session token
  app.get "/loggedin", passport.authenticate("bearer",
    session: false
  ), (req, res) ->
    result =
      name: req.user.name
      token: req.user.token

    
    #...any other info you'd like to provide on a call to loggedin
    res.json result
    return

  
  #
  #    For the routes methods i've followed the convention I originally learned in Rails. You get this for
  #    free with the express-resource module, but you lose the ability to tie in the passportjs middleware,
  #    so it's not used here.
  #
  #    The middleware is included below, but to remove the authentication requirement, remove the 
  #    passport.authenticate line(s).
  #  
  app.get "/api/template", passport.authenticate("bearer",
    session: false
  ), (req, res) ->
    templateController.index.json req, res
    return

  app.post "/api/template", passport.authenticate("bearer",
    session: false
  ), (req, res) ->
    templateController.create.json req, res
    return

  return
