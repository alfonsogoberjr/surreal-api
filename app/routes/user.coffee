mongoose = require("mongoose")
User = mongoose.model("User")
env = process.env.NODE_ENV or "development"
global = require("../../config/config")
config = require("../../config/config")[env]

module.exports = (app, passport, express, logger) ->
  
  #login using the credentials required in the passport.js config
  app.post "/api/user/login", passport.authenticate("local"), (req, res) ->
    req.logIn req.user, (err) ->
      if req.user
        success =
          success: "Logged in."
          email: req.user.email
          token: req.user.token
          name: req.user.name

        success.admin = req.user.admin if req.user.admin
        
        # logger.debug("passport.authenticate returning: " + JSON.stringify(success));
        res.json success
      else
        logger.debug "req.Login error: " + JSON.stringify(err)
        res.send 401, err

  app.post "/api/user/register", (req, res) ->
    u = new User()
    u.email = req.body.email
    u.name = req.body.name
    res.send 401, "Passwords don't match" if req.body.password isnt req.body.passwordConfirm
    u.admin = true if req.body.admin
    console.log req.body, u
    User.addUser u, req.body.password, (err, doc) ->
      res.send 401, err if err
      delete doc.salt
      delete doc.hash
      res.send 201, "User " + doc.name + " (" + doc.email + ") Created"

  #invalidate (remove) the session token from the user account, preventing further logins
  app.get "/api/user/logout", passport.authenticate("bearer",
    session: false
  ), (req, res) ->
    User.logoutUserWithToken req.user.token, (err) ->
      res.send 401, err if err
      req.logout()
      res.send 200, "Have a great day!"

  #check to see if a user is logged in, i.e. their account contains a session token
  app.get "/api/user", passport.authenticate("bearer",
    session: false
  ), (req, res) ->
  	if req.user.admin
  		User.listAllUsers req.user, (err, users) ->
 				res.send 401, err if err
  			res.json users
  	else
    	res.json req.user