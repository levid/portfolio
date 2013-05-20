'use strict'

# Socket service
Application.Services.factory "$socket", ["$rootScope", "User", ($rootScope, User) ->

  # $socket listeners
  # ================

  port = process.env.PORT || 1336
  $socket = io.connect("http://localhost:#{port}")
  # $socket.setMaxListeners(0)

  $socket.on "connect", (stream) ->
    console.log "someone connected!"

    $socket.on 'connectedUsers', (data) ->
      console.log "connected users: ", data
      $rootScope.$apply ->
        $rootScope.connectedUsers = data

    $socket.on 'news', (data) ->
      console.log data
      $socket.emit 'my other event',
        my: 'data'

    $socket.on "onUserAdded", (user) ->
      scope = UsersController.getScope() # Get the scope of the UsersController
      user = User.get user
      console.log "onUserAdded called", user
      # scope.$apply ->
      scope.users.push user

    $socket.on "onUserUpdated", (user) ->
      scope = UsersController.getScope() # Get the scope of the UsersController
      console.log "onUserUpdated called", user
      users = User.query()
      # scope.$apply ->
      scope.users = users

    $socket.on "onUserDeleted", (user) ->
      scope = UsersController.getScope() # Get the scope of the UsersController
      console.log "onUserDeleted called", user
      scope.$apply ->
        scope.users = $.grep(scope.users, (o, i) ->
          o.id is user.id
        , true)

  $socket.on "disconnect", (stream) ->
    console.log "someone disconnected"

  $socket.removeListener "connect"
  $socket.removeListener "news"
  $socket.removeListener "onUserAdded"
  $socket.removeListener "onUserDeleted"
]