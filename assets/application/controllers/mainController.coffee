'use strict'

class MainCtrl
  constructor: () ->
    Application.Controllers.controller "MainCtrl", ["$rootScope", "$scope", "$location", ($rootScope, $scope, $location) ->
      $scope.foo = "booyah"

      $scope.$on '$viewContentLoaded', =>
        # Detect when view content has been loaded and re-initalize jQuery events
        path = $location.path().substr(1, $location.path().length)
        $scope.portfolio = Portfolio
        $scope.portfolio.initAfterViewContentLoaded(path)
    ]

window.MainCtrl = new MainCtrl()