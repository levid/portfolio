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

      if $rootScope.customParams
        if $rootScope.customParams.action == 'index'
          @index($scope, $rootScope.customParams)
        else if $rootScope.customParams.action == 'show'
          @show($scope)


    #### The index action
    #
    # @param [Object] $scope
    #
    # - The $scope object must be passed in to the method
    #   since it is a public static method
    #
    index: ($scope, params) ->
      $scope.projects = Work.query((success) ->
        console.log success
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
      console.log "#{$rootScope.customParams.action} action called"
      if $routeParams.id
        $scope.project = Work.get(
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
        $scope.project = Work.get(
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

      $scope.getWork = (project) ->
        project = Work.get project
        project

      $scope.setOrder = (orderby) ->
        if orderby is $scope.orderby
          $scope.reverse = !$scope.reverse
        $scope.orderby = orderby

      $scope.sortBy = (arr) ->
        arr.category

      $scope.getThumbnails = (data) ->
        images = []
        if data
          images = $.parseJSON(data)
          return images.thumbnails
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

      $scope.addWork = ->
        user = new Work
          name:     $scope.inputData.name     if $scope.inputData.name.length

        Work.save(project,
          success = (data, status, headers, config) ->
            $scope.message  = "New project added!"
            $scope.status   = 200
            $socket.emit "addWork", data # Broadcast to connected subscribers that a project has been added
            $location.path('/projects') # Redirect to projects index
          , error = (data, status, headers, config) ->
            $scope.message  = data.errors
            $scope.status   = status
        )

      $scope.updateWork = (project) ->
        project = {
          id:       $scope.project.id
          name:     $scope.project.name
          # add additional fields from model
        }

        Work.update($scope.project,
          success = (data, status, headers, config) ->
            $scope.message  = "Work updated!"
            $scope.status   = 200
            $socket.emit "updateWork", data # Broadcast to connected subscribers that a project has been updated
            $location.path('/projects') # Redirect to projects index
            $rootScope.project = data

          , error = (data, status, headers, config) ->
            $scope.message  = data.errors
            $scope.status   = status
        )

      $scope.deleteWork = (project) ->
        r = confirm("Are you sure?");
        if r is true
          Work.delete(
            id: project.id
          , (success) ->
            console.log success
            $scope.projects = _.difference($scope.projects, project)
            $socket.emit "deleteWork", project # Broadcast to connected subscribers that a project has been deleted
          , (error) ->
            console.log error
          )
        false

  window.WorkController = new WorkController()

]