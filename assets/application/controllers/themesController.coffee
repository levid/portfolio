'use strict'

Application.Controllers.controller "ThemesController", ["$rootScope", "$scope", "$location", "$socket", "Themes", "SessionService", "$route", "$routeParams", ($rootScope, $scope, $location, $socket, Themes, SessionService, $route, $routeParams) ->

  # ThemesController class that is accessible by the window object
  #
  # @todo add a notifications handler
  # @todo add a proper error handler
  #
  class ThemesController
    opts:
      themeContainerEl: undefined

    #### It's always nice to have a constructor to keep things organized
    #
    constructor: () ->
      @options            = $.extend({}, this.opts, @options)
      @themeContainerEl   = @options.themeContainerEl or $(".theme-container")
      @initScopedMethods()
      $scope.themes = Themes.findAll()

      $('.themes-list').on 'click', 'li', (e) ->
        e.preventDefault()
        $('.themes-list').find('li').removeClass 'active'
        $UI.Theme.chooseBackgroundImage $(this).index()
        $(this).addClass 'active'

      if $rootScope.customParams
        if $rootScope.customParams.action == 'index'
          @index($scope, $rootScope.customParams)
        else if $rootScope.customParams.action == 'show'
          @show($scope)

      $.subscribe('initAfterViewContentLoaded.Portfolio', @initAfterViewContentLoadedProxy('initAfterViewContentLoaded.Portfolio'))

    initAfterViewContentLoadedProxy: () ->
      # Skip the first argument (event object) but log the other args.
      (_, options) =>
        # $UI.hideLoadingScreen()
        if $UI.Constants.sidebarMenuOpen is true then Portfolio.openSidebarMenu() else Portfolio.openSidebar()

    #### The index action
    #
    # @param [Object] $scope
    #
    # - The $scope object must be passed in to the method
    #   since it is a public static method
    #
    index: ($scope, params) ->
      # themesArr = []
      # themes = Themes.findAll((themes) ->
      #   themesArr.push(themes)
      # , (error) ->
      #   console.log error
      # )



      setTimeout(=>
        $('.themes-list').waitForImages (=>
          active             = $UI.Constants.activeTheme
          backgroundImage    = @themeContainerEl.find("li.active img").data('background')
          backgroundPosition = @themeContainerEl.find("li.active img").data('position') or 'bottom left'

          activeEl = $('.themes-list').find("li:eq(#{active})")
          $(activeEl).addClass 'active'
          $UI.hideLoadingScreen()
        ), $.noop, true
      , 1000)

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

      $scope.getThemes = () ->
        themes = Themes.query((themes) ->
          console.log themes
          $scope.themes = themes
        , (error) ->
          console.log error
        )

  window.ThemesController = new ThemesController()

]