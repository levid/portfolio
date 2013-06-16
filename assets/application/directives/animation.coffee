Application.Directives.directive "myCustomDirective", ["$animator", ($animator) ->
  link: ($scope, element, attrs) ->

    #the attrs object is where the ngAnimate attribute is defined
    animator = $animator(attrs)

    #injects the element into the DOM then animates
    animator.enter element, parent

    #animates then removes the element from the DOM
    animator.leave element

    #moves it around in the DOM then animates
    animator.move element, parent, sibling

    #sets CSS display=block then animates
    animator.show element

    #animates then sets CSS display=none
    animator.hide element
]