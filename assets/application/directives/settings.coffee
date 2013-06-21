# A simple directive to display a gravatar image given an email
Application.Directives.directive "ngSettings", [->
  restrict: "EAC" # call directive using an element, attribute or class. - See more at: http://codingsmackdown.tv/blog/2012/12/14/creating-a-simple-angularjs-directive/#sthash.z2t8zlJs.dpuf
  link: (scope, element, attrs) ->
    $(element).on 'click', (e) ->
      e.preventDefault()

    scope.$watch attrs.audio, (value) ->
      setElementState(value)

    scope.$watch attrs.notifications, (value) ->
      setElementState(value)

    scope.$watch attrs.shuffleLetters, (value) ->
      setElementState(value)

    setElementState = (value) ->
      if value is true
        element.addClass("on").removeClass "off"
      else element.addClass("off").removeClass "on" if value is false
]