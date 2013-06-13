'use strict'
#### ScrollSidebar class
#
# @extends UI
#
# - This class extends the Portfolio.UI class
#
class ScrollSidebar extends Portfolio.UI
  opts:
    offsets:            { x: 0, y: 0 }
    mode:               'vertical'
    positionVertical:   'top'
    positionHorizontal: 'right'
    speed:              550

  #### The constructor for the ScrollSidebar class
  #
  # @param [Object] options
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (menu, @options) ->
    @options  = $.extend({}, this.opts, @options)
    @menu     = $(menu)
    @move     = if @options.mode is 'vertical' then 'y' else 'x'
    @property = if @move is 'y' then 'positionVertical' else 'positionHorizontal'

    # start listening
    @startListeners()

    # $.subscribe('initAfterViewContentLoaded.Portfolio', @initAfterViewContentLoadedProxy('initAfterViewContentLoaded.Portfolio'))

    # return this to make this class chainable
    return this

  initAfterViewContentLoadedProxy: () ->
    # Skip the first argument (event object) but log the other args.
    (_, path) =>
      # @displayNotification
      #   message: "Viewing #{path}"

  startListeners: () ->
    action = () =>
      checkIfBottomReached = () =>
        if ($("section.content .innerContent")[0].scrollHeight - $("section.content .innerContent").scrollTop() + "px") is $("section.content .innerContent").css('height')
          return true
        false
      measureAndMove = () =>
        # if checkIfBottomReached() is false
        @setPosition($("#main").scrollTop() + @options.offsets[@move])
      clearTimeout(@setPositionTimer)
      @setPositionTimer = setTimeout(measureAndMove, 150)

    $("#main").on 'scroll', (e) => action()
    $(window).on 'load', (e) => action()

  setPosition: (move) ->
    if @menu.parents('nav')[0]?
      move = 0 if $(window).scrollTop() <= $(@menu.parents('nav')[0]).position().top
    move = 0 if move < 0

    @menu.stop().animate
      top: move
    ,
      duration: 1000
      easing: "easeInOutQuint"
      complete: () =>

    this

# Assign this class to the Portfolio Namespace
Portfolio.UI.ScrollSidebar = ScrollSidebar