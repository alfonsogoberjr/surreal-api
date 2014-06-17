"use strict"
logger = require("../../config/logger")
mongoose = require("mongoose")
env = process.env.NODE_ENV or "development"
global = require("../../config/config")
config = require("../../config/config")[env]
pass = require("pwd")
Schema = mongoose.Schema
userSchema = new Schema(
  email:
    type: String
    index:
      unique: true

  salt: String
  hash: String
  name: String
  token: String
  admin: Boolean
)
userSchema.pre "save", (next) ->
  self = this
  mongoose.models.User.findOne
    email: self.email
  , (err, user) ->
    if err
      throw (err)
    else if user
      self.invalidate "email", "email must be unique"
      next new Error("email must be unique")
    else
      logger.debug("didn't find user with email: " + self.email);
      next()
    return

  next()
  return

userSchema.statics.isValidUserPassword = (email, password, done) ->
  @findOne
    email: email
  , (err, user) ->
    return done(err)  if err
    unless user
      return done(
        message: "User not found."
      , null)
    pass.hash password, user.salt, (err, hash) ->
      return done(err, null)  if err
      return done(null, user)  if hash is user.hash
      done
        message: "Incorrect password."
      , null
      return

    return

  return

userSchema.statics.logoutUserWithToken = (token, done) ->
  @findOne
    token: token
  , (err, user) ->
    return done(err)  if err
    unless user
      return done(
        error: "User with token not found."
      , null)
    user.token = ""
    user.save (err) ->
      return done(err)  if err
      done null

userSchema.statics.addUser = (user, password, done) ->
  pass.hash password, (err, salt, hash) ->
    throw err  if err
    user.salt = salt
    user.hash = hash
    user.save (err, doc) ->
      return done(err, null)  if err
      done null, doc

userSchema.statics.listAllUsers = (admin, done) ->
  if admin.admin
    @find {}, (err, users) ->
      userMap = {};
      users.forEach (user) ->
        userMap[user._id] = user;
      done(null, userMap)

User = mongoose.model("User", userSchema)
module.exports = User
