'use strict'

Application.Controllers.controller "HomeController", ["$rootScope", "$scope", "$location", "$socket", "SessionService", "$route", "$routeParams", ($rootScope, $scope, $location, $socket, SessionService, $route, $routeParams) ->

  # HomeController class that is accessible by the window object
  #
  # @todo add a notifications handler
  # @todo add a proper error handler
  #
  class HomeController

    #### It's always nice to have a constructor to keep things organized
    #
    constructor: () ->
      if $rootScope.customParams
        if $rootScope.customParams.action == 'index'
          @index($scope, $rootScope.customParams)
        else if $rootScope.customParams.action == 'show'
          @show($scope)

      $.subscribe('initAfterViewContentLoaded.Portfolio', @initAfterViewContentLoadedProxy('initAfterViewContentLoaded.Portfolio'))

    initAfterViewContentLoadedProxy: () ->
      # Skip the first argument (event object) but log the other args.
      (_, path) =>
        if path is "home" then $UI.hideLoadingScreen()

    #### The index action
    #
    # @param [Object] $scope
    #
    # - The $scope object must be passed in to the method
    #   since it is a public static method
    #
    index: ($scope, params) ->


  window.HomeController = new HomeController()

]