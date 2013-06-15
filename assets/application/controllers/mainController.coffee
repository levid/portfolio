'use strict'

Application.Controllers.controller "MainCtrl", ["$rootScope", "$scope", "$location", "configuration", "Themes", ($rootScope, $scope, $location, configuration, Themes) ->
  class MainCtrl
    constructor: () ->
      $scope.foo = "booyah"

      $scope.$on '$viewContentLoaded', =>
        # Detect when view content has been loaded and re-initalize jQuery events
        path = $location.path().substr(1, $location.path().length)

        $scope.portfolio = Portfolio
        $scope.portfolio.initAfterViewContentLoaded(path)
        $scope.s3_path = configuration.s3_path

  window.MainCtrl = new MainCtrl()
]