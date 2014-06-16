#!/usr/bin/env node
require "should"
mongoose = require("mongoose")
env = process.env.NODE_ENV or "development"
global = require("../config/config.coffee")
config = require("../config/config.coffee")[env]
util = require("../util.coffee")
pass = require("pwd")
require "../app/models/user.coffee"
program = require("commander")
promptly = require("promptly")

program.version("0.0.1").option("-e, --email <email address>", "Email address to add. This will be the login id", String).parse process.argv

console.log "info", "environment: " + env
if program.email is `undefined`
  console.log "email address is required"
  process.exit 1
unless mongoose.connection.readyState
  console.log "connecting to mongo at " + config.db
  mongoose.connect config.db, (err) ->
    addUser()
    throw err  if err

addUser = ->
  User = mongoose.model("User")
  u = new User()
  u.email = program.email
  promptly.prompt "name (First Last):", (err, name) ->
    console.log "Got name: %s", name
    u.name = name
    promptly.password "Password: ", (err, password) ->
      throw err  if err
      promptly.password "One more time: ", (err, passwordConfirm) ->
        throw err  if err
        throw "Passwords don't match"  if password isnt passwordConfirm
        User.addUser u, password, (err, doc) ->
          throw err  if err
          delete doc.salt

          delete doc.hash

          console.log "added user " + JSON.stringify(doc.email) + "."
          process.exit 0
          return

        return

      return

    return

  return