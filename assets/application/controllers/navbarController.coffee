'use strict'

Application.Controllers.controller "NavbarController", ["$scope", "$location", "Clients", "Projects", ($scope, $location, Clients, Projects) ->
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
      $scope.projectsNavMenu = Projects.findAll()

    #### Scoped methods
    #
    # These are helper methods accessible to the angular user views
    #
    initScopedMethods: () ->
      $scope.getClients = () ->
        clientsArr = [{}]
        clients = Projects.query((projects) ->
          # $.each client, (k, v) =>

          $.extend(clientsArr, projects.client, clientsArr)
        , (error) ->
          console.log error
        )

        $scope.clients = clientsArr

      $scope.getClass = (path) ->
        if $location.path().substr(0, path.length) is path
          true
        else
          false

      $scope.getSlug = (slug) ->
        currentPath = $location.path().substr(0, $location.path().length)
        if currentPath.indexOf(slug) >= 0
          true
        else
          false

  window.NavbarController = new NavbarController()
]