module.exports = (server, logger) ->
  sockjs = require("sockjs")
  
  #TODO (for me or you): use something like STOMP to standardize the back and forth messaging
  #JSON seems like it makes sense since we're dealing with a web app, though
  socketConnections = []
  socketServer = sockjs.createServer()
  socketServer.on "connection", (conn) ->
    socketConnections.push conn
    number = socketConnections.length
    conn.write JSON.stringify(info: "connected!")
    logger.info "socket connection #" + socketConnections.length
    
    # logger.info('connections: ' + u.inspect(socketConnections));
    conn.on "incomingMessage", (message) ->
      logger.debug "incomingMessage received: " + JSON.stringify(message)
      ii = 0

      while ii < socketConnections.length
        socketConnections[ii].write message
        ii++
      return

    conn.on "close", ->
      ii = 0

      while ii < socketConnections.length
        logger.debug "connection was closed"
        socketConnections[ii].write "User " + number + " has disconnected"
        ii++
      return

    return

  
  # socketConnections.pop(conn);
  socketServer.installHandlers server,
    prefix: "/socket"

  return
