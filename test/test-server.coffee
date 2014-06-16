"use strict"
should = require("should")
logger = require("winston")
testFixtures = require("./fixtures/fixtures.coffee")
testUtils = require("./utils.coffee")
require "Array.prototype.forEachAsync"
request = require("supertest")
app = require("../server.coffee")
env = process.env.NODE_ENV or "test"
global = require("../config/config.coffee")
config = require("../config/config.coffee")[env]
require "Array.prototype.forEachAsync"
util = require("../util.coffee")
u = require("util")
pass = require("pwd")
randomElement = undefined

beforeEach (done) ->
  randomElement = Math.floor(Math.random() * 5)
  mongoose = require("mongoose")
  User = mongoose.model("User")
  
  #Load users from test/fixtures.js
  
  
  testFixtures.users.forEachAsync((next, user) ->
    u = new User(user)
    u.token = util.newToken()
    User.addUser u, user.password, (err, doc) ->
      console.log("added: " + JSON.stringify(u))
      throw err  if err
      next()
      return

    return
  ).then (next) ->
    logger.info "loaded Users..."
    done()
    return

  return

describe "POST /login", ->
  it "returns 401 Unauthorized on bad creds", (done) ->
    badUser =
      email: "not@existing.com"
      password: "nomatter"

    request(app).post("/login").set("Accept", "application/json").send(badUser).expect 401, done
    return

  it "returns 401 Unauthorized on bad pass", (done) ->
    badPass =
      email: "estellalawrence@quordate.com"
      password: "notgonnagetit"

    request(app).post("/login").set("Accept", "application/json").send(badPass).expect 401, done
    return

  it "logs a user in with proper credentials", (done) ->
    validUser =
      email: "estellalawrence@quordate.com"
      password: "exercitation20"

    request(app).post("/login").set("Accept", "application/json").expect("Content-Type", /json/).send(validUser).expect(200).expect(/"success"/).expect /"token"/, done
    return

  return

