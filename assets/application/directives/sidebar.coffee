Application.Directives.directive "sidebar", ["$timeout", ($timeout) ->
  restrict: "A"
  require: "?ngModel"
  link: (scope, elem, attrs, ngModel) ->
    node = elem[0]

    scope.$watch "projectsNavMenu", (value) ->
      container = $("[data-behavior='scrollable']")
      container.css height: $(window).height() - 250
      container.mCustomScrollbar("update")

    ngModel.$render = ->
      container = $("[data-behavior='scrollable']")
      container.css height: $(window).height() - 250
      container.mCustomScrollbar("update")
]