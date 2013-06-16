'use strict'

Application.Controllers.controller "MainCtrl", ["$rootScope", "$scope", "$location", "configuration", ($rootScope, $scope, $location, configuration) ->
  class MainCtrl
    constructor: () ->
      $scope.foo = "booyah"

      $scope.$on '$viewContentLoaded', =>
        # Detect when view content has been loaded and re-initalize jQuery events
        path = $location.path().substr(1, $location.path().length)

        $scope.portfolio        = Portfolio
        $scope.s3_path          = configuration.s3_path
        $scope.audio            = configuration.audio
        $scope.notifications    = configuration.notifications
        $scope.shuffle_letters  = configuration.shuffle_letters

        $scope.portfolio.initAfterViewContentLoaded(path)

      $scope.toggleAudio = () =>
        if $scope.audio is true then $scope.audio = false else $scope.audio = true

      $scope.toggleNotifications = () =>
        if $scope.notifications is true then $scope.notifications = false else $scope.notifications = true

      $scope.toggleShuffleLetters = () =>
        if $scope.shuffle_letters is true then $scope.shuffle_letters = false else $scope.shuffle_letters = true

    getScope: () =>
      return $scope

  window.MainCtrl = new MainCtrl()
]