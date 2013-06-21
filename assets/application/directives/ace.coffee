Application.Directives.directive "ace", ["$timeout", ($timeout) ->
  resizeEditor = (editor, elem) ->
    lineHeight = editor.renderer.lineHeight
    rows = editor.getSession().getLength()
    $(elem).height rows * lineHeight
    editor.resize()

  restrict: "A"
  require: "?ngModel"
  link: (scope, elem, attrs, ngModel) ->
    node = elem[0]
    editor = ace.edit(node)
    # set editor options
    editor.setTheme("ace/theme/twilight")
    editor.getSession().setMode("ace/mode/text")
    editor.renderer.setShowPrintMargin(false)
    editor.setReadOnly(true)
    editor.setFontSize(13)
    editor.renderer.setShowGutter(false)
    editor.getSession().setUseSoftTabs(true)
    editor.renderer.setHScrollBarAlwaysVisible(false)
    editor.setShowInvisibles(false)
    editor.setDisplayIndentGuides(true)
    editor.setHighlightActiveLine(true)
    editor.setShowPrintMargin(false)

    # scope.$watch "content", (value) ->
    #   editor.setValue value
    #   editor.focus()
    #   editor.gotoLine(1)
    #   editor.getSession().setMode("ace/mode/#{attrs.language}") if attrs.language
    #   resizeEditor editor, elem

    # data binding to ngModel
    ngModel.$render = ->
      editor.setValue ngModel.$viewValue
      editor.focus()
      editor.gotoLine(1)
      editor.getSession().setMode("ace/mode/#{attrs.language}") if attrs.language
      resizeEditor editor, elem

    editor.on "change", (attrs) ->
      $timeout ->
        scope.$apply ->
          value = editor.getValue()
          ngModel.$setViewValue value

      resizeEditor editor, elem
]