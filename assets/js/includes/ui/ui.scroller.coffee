'use strict'
#### Scroller class
#
# @extends UI
#
# - This class extends the Portfolio.UI class
#
# See: http://manos.malihu.gr/jquery-custom-content-scroller/
#
class Scroller extends Portfolio.UI
  opts: {}

  #### The constructor for the Scroller class
  #
  # @param [Object] options
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (@container) ->
    @init(@container)
    @initScroller(@container)

    $(window).on "resize", =>
      clearTimeout resizeTo if resizeTo
      resizeTo = setTimeout(->
        $(this).trigger "resizeEnd"
      , 500)

    $(window).on "resizeEnd", =>
      @resizeEnd(container)

    # $.subscribe('initAfterViewContentLoaded.Portfolio', @initAfterViewContentLoadedProxy('initAfterViewContentLoaded.Portfolio'))

    # return this to make this class chainable
    return this

  initAfterViewContentLoadedProxy: () ->
    # Skip the first argument (event object) but log the other args.
    (_, path) =>
      # @displayNotification
      #   message: "Viewing #{path}"

  init: (container) ->
    $(container).each (el) ->
      if $(this).find('li').length > 1
        $(this).css('height', $(container).css('max-height'))
      else
        $(this).css('height', $(container).css('min-height'))

  initScroller: (container) ->
    $(container).mCustomScrollbar
      set_width: false #optional element width: boolean, pixels, percentage
      set_height: false #optional element height: boolean, pixels, percentage
      horizontalScroll: false #scroll horizontally: boolean
      scrollInertia: 550 #scrolling inertia: integer (milliseconds)
      scrollEasing: "easeOutCirc" #scrolling easing: string
      mouseWheel: true #mousewheel support and velocity: boolean, "auto", integer
      velocity: 100
      autoDraggerLength: true #auto-adjust scrollbar dragger length: boolean
      theme: 'light-thin'
      # normalizeMouseWheelDelta: true
      scrollButtons: #scroll buttons
        enable: false #scroll buttons support: boolean
        scrollType: "continuous" #scroll buttons scrolling type: "continuous", "pixels"
        scrollSpeed: 20 #scroll buttons continuous scrolling speed: integer
        scrollAmount: 40 #scroll buttons pixels scroll amount: integer (pixels)

      advanced:
        updateOnBrowserResize: true #update scrollbars on browser resize (for layouts based on percentages): boolean
        updateOnContentResize: false #auto-update scrollbars on content resize (for dynamic content): boolean
        autoExpandHorizontalScroll: false #auto expand width for horizontal scrolling: boolean

      callbacks:
        onScroll: -> #user custom callback function on scroll event

        onTotalScroll: -> #user custom callback function on bottom reached event

        onTotalScrollOffset: 0 #bottom reached offset: integer (pixels)

  #### Resize End
  #
  # This method is fired if the window is resized or
  # the device orientation changes
  #
  resizeEnd: (container) ->
    $(container).stop().animate
      height: $(window).height() - 250
    , 500, ->
      $(container).mCustomScrollbar("update")


# Assign this class to the Portfolio Namespace
Portfolio.UI.Scroller = Scroller