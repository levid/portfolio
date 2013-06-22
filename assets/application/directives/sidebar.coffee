Application.Directives.directive "sidebar", ["$timeout", ($timeout) ->
  restrict: "A"
  require: "?ngModel"
  link: (scope, elem, attrs, ngModel) ->
    node = elem[0]

    scope.$watch "projectsNavMenu", (value) ->
      $("[data-behavior='scrollable']").mCustomScrollbar("update")

    ngModel.$render = ->
      $("[data-behavior='scrollable']").mCustomScrollbar("update")
]