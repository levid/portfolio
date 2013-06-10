'use strict'

Application.Controllers.controller "ThemesController", ["$rootScope", "$scope", "$location", "$socket", "configuration", "Themes", "SessionService", "$route", "$routeParams", ($rootScope, $scope, $location, $socket, configuration, Themes, SessionService, $route, $routeParams) ->

  # ThemesController class that is accessible by the window object
  #
  # @todo add a notifications handler
  # @todo add a proper error handler
  #
  class ThemesController

    #### It's always nice to have a constructor to keep things organized
    #
    constructor: () ->
      @initScopedMethods()
      $scope.themes   = Themes.findAll()
      $scope.s3_path  = configuration.s3_path

      # return this to make this class chainable
      this


    #### The index action
    #
    # @param [Object] $scope
    #
    # - The $scope object must be passed in to the method
    #   since it is a public static method
    #
    index: ($scope, params) ->
      themesArr = [{}]
      themes = Themes.query((theme) ->
        $.extend(themesArr, theme, themesArr)
      , (error) ->
        console.log error
      )

      $scope.themes = themesArr

    #### The new action
    #
    # @param [Object] $scope
    #
    # - The $scope object must be passed in to the method
    #   since it is a public static method
    #
    new: ($scope) ->
      console.log "#{$rootScope.customParams.action} action called"
      # $scope.user = Themes.get(
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
        $scope.theme = Themes.get(
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
        $scope.theme = Themes.get(
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

      $scope.getThemess = () ->
        console.log "WHAT"
        themes = Themes.query((themes) ->
          console.log themes
          $scope.themes = themes
        , (error) ->
          console.log error
        )

  window.ThemesController = new ThemesController()

]