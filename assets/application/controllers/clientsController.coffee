'use strict'

Application.Controllers.controller "ClientsController", ["$rootScope", "$scope", "$location", "$socket", "Clients", "SessionService", "$route", "$routeParams", ($rootScope, $scope, $location, $socket, Clients, SessionService, $route, $routeParams) ->

  # ClientController class that is accessible by the window object
  #
  # @todo add a notifications handler
  # @todo add a proper error handler
  #
  class ClientsController

    #### It's always nice to have a constructor to keep things organized
    #
    constructor: () ->
      @initScopedMethods()

      if $rootScope.customParams
        if $rootScope.customParams.action == 'index'
          @index($scope, $rootScope.customParams)
        else if $rootScope.customParams.action == 'show'
          @show($scope)

      $.subscribe('initAfterViewContentLoaded.Portfolio', @initAfterViewContentLoadedProxy('initAfterViewContentLoaded.Portfolio'))

    initAfterViewContentLoadedProxy: () ->
      # Skip the first argument (event object) but log the other args.
      (_, options) =>
        if $UI.Constants.sidebarMenuOpen is true then Portfolio.openSidebarMenu() else Portfolio.openSidebar()

    #### The index action
    #
    # @param [Object] $scope
    #
    # - The $scope object must be passed in to the method
    #   since it is a public static method
    #
    index: ($scope, params) ->
      $UI.hideLoadingScreen()
      _gaq.push ['_trackEvent', 'Page', 'Viewed', $UI.Constants.path]
      clientsArr = []
      startupsArr = []
      clients = Clients.findAll((clients) ->
        $.each clients, (k, v) =>
          if v.is_startup is true
            startupsArr.push(v)
          else if v.is_startup is false
            clientsArr.push(v)

        $scope.clients = clientsArr
        $scope.startups = startupsArr
        $scope.predicate = 'name'

        clearTimeout columnTimeout if columnTimeout
        columnTimeout = setTimeout(=>
          $('.clients ul').columnize
            columns: 4
        , 700)

      , (error) ->
        console.log error
      )

    #### The new action
    #
    # @param [Object] $scope
    #
    # - The $scope object must be passed in to the method
    #   since it is a public static method
    #
    new: ($scope) ->
      console.log "#{$rootScope.customParams.action} action called"
      # $scope.user = Client.get(
      #   action: "new"
      # , (resource) ->
      #   console.log resource
      # , (response) ->
      #   console.log response
      # )


    #### The edit action
    #
    # @param [Object] $scope
    #
    # - The $scope object must be passed in to the method
    #   since it is a public static method
    #
    edit: ($scope) ->
      console.log "#{$rootScope.customParams.action} action called"
      if $routeParams.id
        $scope.client = Client.get(
          id: $routeParams.id
          action: "edit"
        , (success) ->
          console.log success
        , (error) ->
          console.log error
        )

    #### The show action
    #
    # @param [Object] $scope
    #
    # - The $scope object must be passed in to the method
    #   since it is a public static method
    #
    show: ($scope) ->
      console.log "#{$rootScope.customParams.action} action called"
      if $routeParams.id
        $scope.client = Client.get(
          id: $routeParams.id
        , (success) ->
          console.log success
        , (error) ->
          console.log error
        )

    #### Get current scope
    #
    # This method acts as a public static method to grab the
    # current $scope outside of this class.
    # (ex: socket.coffee)
    #
    getScope: () ->
      return $scope

    #### Scoped methods
    #
    # These are helper methods accessible to the angular user views
    #
    initScopedMethods: () ->
      $scope.showMessage = ->
        $scope.message && $scope.message.length

      $scope.getClient = (client) ->
        client = Client.get client
        client

      $scope.setOrder = (orderby) ->
        if orderby is $scope.orderby
          $scope.reverse = !$scope.reverse
        $scope.orderby = orderby

      $scope.sortBy = (arr) ->
        arr.category

      $scope.getImages = (data) ->
        images = []
        if data and data isnt undefined
          images.push(data)
          $scope.images = images
        false

      $scope.getLargeImages = (data) ->
        images = []
        if data
          images = $.parseJSON(data)
          return images.large
        false

      $scope.getTags = (data) ->
        tags = []
        if data
          tags = $.parseJSON(data)
          return tags
        false

      $scope.addClient = ->
        user = new Client
          name:     $scope.inputData.name     if $scope.inputData.name.length

        Client.save(client,
          success = (data, status, headers, config) ->
            $scope.message  = "New client added!"
            $scope.status   = 200
            $socket.emit "addClient", data # Broadcast to connected subscribers that a client has been added
            $location.path('/clients') # Redirect to clients index
          , error = (data, status, headers, config) ->
            $scope.message  = data.errors
            $scope.status   = status
        )

      $scope.updateClient = (client) ->
        client = {
          id:       $scope.client.id
          name:     $scope.client.name
          # add additional fields from model
        }

        Client.update($scope.client,
          success = (data, status, headers, config) ->
            $scope.message  = "Client updated!"
            $scope.status   = 200
            $socket.emit "updateClient", data # Broadcast to connected subscribers that a client has been updated
            $location.path('/clients') # Redirect to clients index
            $rootScope.client = data

          , error = (data, status, headers, config) ->
            $scope.message  = data.errors
            $scope.status   = status
        )

      $scope.deleteClient = (client) ->
        r = confirm("Are you sure?");
        if r is true
          Client.delete(
            id: client.id
          , (success) ->
            console.log success
            $scope.clients = _.difference($scope.clients, client)
            $socket.emit "deleteClient", client # Broadcast to connected subscribers that a client has been deleted
          , (error) ->
            console.log error
          )
        false

  window.ClientsController = new ClientsController()

]