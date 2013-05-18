'use strict'

class MainCtrl
  constructor: () ->
    Application.Controllers.controller "MainCtrl", ["$scope", ($scope) ->
      $scope.foo = "booyah"

      $scope.$on '$viewContentLoaded', =>
        # Detect when view content has been loaded and re-initalize jQuery events
        $scope.portfolio = window.portfolio
        $scope.portfolio.initAfterViewContentLoaded()
    ]

window.MainCtrl = new MainCtrl()