#### Utilities class
#
# @extends UI
#
# - This class extends the Portfolio.UI class
#
class Utils extends Portfolio.UI

  #### The constructor for the Utilities class
  #
  # @param [Object] options
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (@options) ->
    # return this to make this class chainable
    this

    window.log         = this.log
    window.getCacheKey = this.getCacheKey

    $.fn.redraw = ->
      $(this).each ->
        redraw = @offsetHeight

    $.fn.spin = (opts) ->
      @each ->
        $this = $(this)
        data  = $(this).data()
        if data.spinner
          data.spinner.stop()
          delete data.spinner
        if opts isnt false
          data.spinner = new Spinner($.extend(
            color: $(this).css("color")
          , opts)).spin(this)
        if opts is 'stop'
          data.spinner.stop()
          delete data.spinner
      this

  #   accessors =
  #     sortable:
  #       get: @generateGetMethod("sortable")

  #     droppable:
  #       get: @generateGetMethod("droppable")

  # generateGetMethod: (attr) ->
  #   =>
  #     @getAttribute(attr)

  # getAttribute: (attr) ->
  #   return attr

  #### Hide URL Bar
  #
  hideURLBar: (orientation) ->
    w         = $(window).width()
    h         = $(window).height()
    @app      = $(parent.app)
    @wrapper  = $(parent.wrapper) # page wrapper - might hold global nav etc.

    # scroll to hide url bar in iOS
    if isMobile.iOS()
      log "IsMobile.iOS: " + isMobile.iOS()

      @wrapper.css
        width: w
        height: if iOSDevice != 'iPad' then h + 60 else h

      if orientation is 'landscape'
        @wrapper.css
          marginTop: 0
      else
        # for canvas apps: set absolute pixel size of drawing context
        @wrapper.css
          marginTop: 40

        # Fix preloader cropping issue
        $('#preloader').css
          height: h + 35
          marginTop: -10

      setTimeout (->
        # Hide the address bar!
        window.scrollTo 0, 1
      ), 0

  #### Hide Browser Bar Method
  #
  # @param [Object] container
  # - The container element used to calculate the height of the screen
  #
  hideBrowserBar: (container) ->
    page        = $(container)
    ua          = navigator.userAgent
    iphone      = (~ua.indexOf("iPhone") or ~ua.indexOf("iPod")) and not ~ua.indexOf("CriOS")
    ipad        = ~ua.indexOf("iPad")
    ios         = (iphone or ipad)
    fullscreen  = window.navigator.standalone
    android     = ~ua.indexOf("Android")
    lastWidth   = 0

    if android
      window.onscroll = ->
        page.style.height = $(window).innerHeight + "px"

    #todo: exclude chrome on ios as you can't hide the url bar
    if ios
      height = document.documentElement.clientHeight
      height += 60  if iphone and not fullscreen
      page.style.height = height + "px"

    setTimeout scrollTo, 0, 0, 1

  #### Get random number between two values
  #
  # @param [Integer] min
  # - The minimum number that can be returned
  #
  # @param [Integer] mac
  # - The maximum number that can be returned
  #
  getRandomNumberBetween: (min, max, float) ->
    if float?
      Math.random()*(max-min+1)+min
    else
      Math.floor(Math.random()*(max-min+1)+min)

  getCacheKey: () ->
    if HappyPlace.isCacheBustingEnabled() is 'true' then "?" + ('' + Math.random() + (new Date).getTime()).substr(10) else ''

  #### Check to see if a specified browser property is allowed
  #
  # @param [String] prop
  # - The class name to look for in the DOM
  #
  hasProperty: (prop) ->
    return $('html').hasClass(prop)

  #### Parse Query String
  #
  # Check the query string for a starting point string and convert it
  # into a usable array.
  #
  parseQueryString: () ->
    params          = $.deparam.querystring()
    startPointArray = new Array()
    startPointArray = if params.startAt? then params.startAt.split('-') else [0,0,0,0]
    return startPointArray

  #### Attach an overlay that incldues an optional message
  #
  # @param [String] message
  # - The message to display in the overlay (optional)
  #
  attachOverlay: (message) ->
    overlay = $("<div id=\"happy-overlay\" />")
    overlay.append "<span><b>#{message}</b></span>"
    $("#wrapper").append overlay unless $("#happy-overlay").length

  #### Remove the overlay
  #
  # Destroy the overlay from the DOM
  #
  removeOverlay: () ->
    $("#happy-overlay").fadeOut('fast', ->
      $(this).remove()
    )

  # helper method to get the current time to calculate duration
  getTime: () ->
    date = new Date()
    date.getTime()
    date

  #### Global Log Method
  #
  # This cool logging method allows objects to be printed to the console instead of just showing [Object, object]
  #
  log: (message) ->
    params = $.deparam.querystring()
    if params.traceToConsole? # set ?traceToConsole=true to display logging
      f     = console.log
      args  = Array::slice.call(arguments)

      if args.length and args[0] is "!"
        args.shift()
        f = console.warn
      try
        f.apply console, args
      catch ex
        f args.join(" ")

# Assign this class to the Portfolio Namespace
Portfolio.UI.Utils = new Utils()