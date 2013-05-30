'use strict'

Application.Controllers.controller "NavbarController", ["$scope", "$location", "Clients", ($scope, $location, Clients) ->
  # NavbarController class that is accessible by the window object
  #
  # @todo add a notifications handler
  # @todo add a proper error handler
  #
  class NavbarController

    #### It's always nice to have a constructor to keep things organized
    #
    constructor: () ->
      @initScopedMethods()
      $scope.clients = Clients.query()

    #### Scoped methods
    #
    # These are helper methods accessible to the angular user views
    #
    initScopedMethods: () ->
      $scope.getClients = () ->
        clientsArr = [{}]
        clients = Clients.query((client) ->
          # $.each client, (k, v) =>

          $.extend(clientsArr, client, clientsArr)
        , (error) ->
          console.log error
        )

        $scope.clients = clientsArr

      $scope.getClass = (path) ->
        if $location.path().substr(0, path.length) is path
          true
        else
          false

  window.NavbarController = new NavbarController()
]