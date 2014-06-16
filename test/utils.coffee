"use strict"

#
#* Modified from https://github.com/elliotf/mocha-mongoose
#
env = process.env.NODE_ENV or "test"
global = require("../config/config.coffee")
config = require("../config/config.coffee")[env]
mongoose = require("mongoose")
beforeEach (done) ->
  clearDB = ->
    for i of mongoose.connection.collections
      mongoose.connection.collections[i].remove ->

    console.log "\nbeforeEach.clearDB: db cleared"
    done()
  if mongoose.connection.readyState is 0
    mongoose.connect config.db, (err) ->
      throw err  if err
      clearDB()

  else
    clearDB()
  return

afterEach (done) ->
  mongoose.disconnect()
  done()


#pull a user from the fixtures
exports.getUser = (index, cb) ->
  User = mongoose.model("User")
  q = User.find({}).skip(index)
  q.exec (err, doc) ->
    cb err, null  if err
    cb null, doc[0]
    return

  return
