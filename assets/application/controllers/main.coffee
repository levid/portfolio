'use strict'

class MainCtrl
  constructor: () ->
    Application.Controllers.controller "MainCtrl", ["$scope", ($scope) ->
      $scope.foo = "booyah"

      $scope.$on '$viewContentLoaded', =>
        # Detect when view content has been loaded and re-initalize jQuery events
        $scope.portfolio = new window.portfolio()
    ]

window.MainCtrl = new MainCtrl()