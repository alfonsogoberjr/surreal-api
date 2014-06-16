should = require("should")
logger = require("winston")
testFixtures = require("./fixtures/fixtures.coffee")
testUtils = require("./utils.coffee")
require "Array.prototype.forEachAsync"
util = require("../util.coffee")
mongoose = require("mongoose")
env = process.env.NODE_ENV or "test"
global = require("../config/config.coffee")
config = require("../config/config.coffee")[env]
pass = require("pwd")
require "../app/models/user.coffee"

#connect mongoose
unless mongoose.connection.readyState
  logger.info "connecting to mongo at " + config.db
  mongoose.connect config.db, (err) ->
    throw err  if err
    console.log "Connected to Mongo at: " + config.db
    return

beforeEach (done) ->
  User = mongoose.model("User")
  logger.debug "beforeEach() removed users"
  
  #add a bonafide password to each user in the fixtures file
  testFixtures.users.forEachAsync((next, user) ->
    u = new User(user)
    pass.hash user.password, (err, salt, hash) ->
      throw err  if err
      u.salt = salt
      u.hash = hash
      u.save (err, doc) ->
        throw err  if err
        next()
        return

      return

    return
  ).then (next) ->
    logger.debug "beforeEach: fixtures loaded"
    done()
    return

  return

describe "User", ->
  describe "password", (done) ->
    it "should fail on bad email addy", (done) ->
      User = mongoose.model("User")
      User.isValidUserPassword "callahanfarley@retrack239er.com", "notgonnawork", (err, user) ->
        should.exist err
        done()
        return

      return

    it "should fail on bad pass", (done) ->
      User = mongoose.model("User")
      User.isValidUserPassword "callahanfarley@retrack.com", "notgonnawork", (err, user) ->
        should.exist err
        done()
        return

      return

    it "should succeed on valid pass", (done) ->
      User = mongoose.model("User")
      User.isValidUserPassword "callahanfarley@retrack.com", "exercitation15", (err, user) ->
        should.exist user
        user.email.should.equal "callahanfarley@retrack.com"
        done()
        return

      return

    return

  it "should not allow duplicate emails on save", (done) ->
    User = mongoose.model("User")
    dupUser =
      name: "Johnny Test"
      email: "johnny@example.com"
      password: "johnnyshere1"

    u = new User(dupUser)
    u.save (err, doc) ->
      done()
      return

    return

  return

