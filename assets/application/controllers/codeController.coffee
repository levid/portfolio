'use strict'

Application.Controllers.controller "CodeController", ["$rootScope", "$scope", "configuration", "$location", "$socket", "Code", "Projects", "Technologies", "SessionService", "$route", "$routeParams", ($rootScope, $scope, configuration, $location, $socket, Code, Projects, Technologies, SessionService, $route, $routeParams) ->

  # CodeController class that is accessible by the window object
  #
  class CodeController

    #### It's always nice to have a constructor to keep things organized
    #
    constructor: () ->
      @initScopedMethods()

      if $rootScope.customParams
        if $rootScope.customParams.action == 'index'
          @index($scope, $rootScope.customParams)
        else if $rootScope.customParams.action == 'show'
          @show($scope, $rootScope.customParams)

      $scope.path = $location.path()
      $scope.s3_path = configuration.s3_path
      $scope.category = $rootScope.customParams.category

      $.subscribe('initAfterViewContentLoaded.Portfolio', @initAfterViewContentLoadedProxy('initAfterViewContentLoaded.Portfolio'))

      # return this to make this class chainable
      this

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


    #### The show action
    #
    # @param [Object] $scope
    #
    # - The $scope object must be passed in to the method
    #   since it is a public static method
    #
    show: ($scope, params) ->
      $UI.Constants.actionPath = $rootScope.customParams.action

      if $routeParams.slug
        projectsArr = [{}]
        projects = Projects.find(
          slug: $routeParams.slug
        , (project) ->
          $.each project.technology_ids, (key, val) ->
            if val isnt ''
              Technologies.find({id: project.sample_language}, (technology) ->
                $scope.editorMode = technology.editor_mode
                $scope.language = technology.name
              )

          if project.sample_code
            $scope.content      = 'Loading code...'
            $scope.filePath     = project.sample_code

            $UI.showSpinner $('.info-container').find('.spinner'),
              lines: 12
              length: 0
              width: 3
              radius: 13
              color: '#ffffff'
              speed: 1.6
              trail: 45
              shadow: false
              hwaccel: false

            Code.getFileContents
              path: $scope.filePath
            , (contents) ->
              $scope.content = contents.body
              $UI.hideSpinner $('.info-container .spinner')

          else
            $scope.content = 'There is no code available for this project.'
          $scope.project = project
          $UI.hideLoadingScreen()

        , (error) ->
          log error
        )

    initScopedMethods: () ->
      $scope.goBack = () ->
        $location.path(history.back())

      $scope.go = (path) ->
        $location.path(path)

  window.CodeController = new CodeController()

]