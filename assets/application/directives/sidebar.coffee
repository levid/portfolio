Application.Directives.directive "sidebar", ["$timeout", ($timeout) ->
  restrict: "A"
  require: "?ngModel"
  link: (scope, elem, attrs, ngModel) ->
    node = elem[0]

    ngModel.$render = ->
      $("[data-behavior=scrollable]").mCustomScrollbar("update")
]