'use strict'

Application.Controllers.controller "WorkController", ["$rootScope", "$scope", "$location", "$socket", "User", "Work", "SessionService", "$route", "$routeParams", ($rootScope, $scope, $location, $socket, User, Work, SessionService, $route, $routeParams) ->

  # WorkController class that is accessible by the window object
  #
  # @todo add a notifications handler
  # @todo add a proper error handler
  #
  class WorkController

    #### It's always nice to have a constructor to keep things organized
    #
    constructor: () ->
      @initScopedMethods()

      path = $location.path().substr(1, $location.path().length)

      if path is 'design'
        @index($scope, path)


    #### The index action
    #
    # @param [Object] $scope
    #
    # - The $scope object must be passed in to the method
    #   since it is a public static method
    #
    index: ($scope, path) ->
      $scope.projects = Work.query((success) ->
        console.log success
      , (error) ->
        console.log error
      )

    # index: ($scope, path) ->
    #   console.log "#{$rootScope.action} action called"
    #   $scope.projects = Work.findAll({ category: path}
    #   , (success) ->
    #     console.log success
    #   , (error) ->
    #     console.log error
    #   )


    #### The new action
    #
    # @param [Object] $scope
    #
    # - The $scope object must be passed in to the method
    #   since it is a public static method
    #
    new: ($scope) ->
      console.log "#{$rootScope.action} action called"
      # $scope.user = Work.get(
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
      console.log "#{$rootScope.action} action called"
      if $routeParams.id
        $scope.user = Work.get(
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
      console.log "#{$rootScope.action} action called"
      if $routeParams.id
        $scope.user = Work.get(
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

      $scope.getWork = (user) ->
        user = Work.get user
        user

      $scope.setOrder = (orderby) ->
        if orderby is $scope.orderby
          $scope.reverse = !$scope.reverse
        $scope.orderby = orderby

      $scope.sortBy = (arr) ->
        arr.category

      $scope.getThumbnails = (data) ->
        images = []
        if data.indexOf("[") > -1
          images = $.parseJSON(data)
        else
          images.push(data)

        $scope.images = images

      $scope.addWork = ->
        user = new Work
          name:     $scope.inputData.name     if $scope.inputData.name.length
          email:    $scope.inputData.email    if $scope.inputData.email.length
          password: $scope.inputData.password if $scope.inputData.password.length

        Work.save(user,
          success = (data, status, headers, config) ->
            $scope.message  = "New user added!"
            $scope.status   = 200
            $socket.emit "addWork", data # Broadcast to connected subscribers that a user has been added
            $location.path('/projects') # Redirect to projects index
          , error = (data, status, headers, config) ->
            $scope.message  = data.errors
            $scope.status   = status
        )

      $scope.updateWork = (user) ->
        user = {
          id:       $scope.user.id
          name:     $scope.user.name
          email:    $scope.user.email
          password: $scope.inputData.password
        }

        Work.update($scope.user,
          success = (data, status, headers, config) ->
            $scope.message  = "Work updated!"
            $scope.status   = 200
            $socket.emit "updateWork", data # Broadcast to connected subscribers that a user has been updated
            $location.path('/projects') # Redirect to projects index
            $rootScope.user = data

          , error = (data, status, headers, config) ->
            $scope.message  = data.errors
            $scope.status   = status
        )

      $scope.deleteWork = (user) ->
        r = confirm("Are you sure?");
        if r is true
          Work.delete(
            id: user.id
          , (success) ->
            console.log success
            $scope.projects = _.difference($scope.projects, user)
            $socket.emit "deleteWork", user # Broadcast to connected subscribers that a user has been deleted
          , (error) ->
            console.log error
          )
        false

  window.WorkController = new WorkController()

]