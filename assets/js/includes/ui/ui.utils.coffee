'use strict'
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
    window.log = this.log
    @enableSVGfallback()

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

    # Extend jQuery with a center() method. Usage: $(element).center()
    $.fn.extend center: ->
      @each ->
        top = ($(window).height() - $(this).outerHeight()) / 2
        left = ($(window).width() - $(this).width()) / 2

        $(this).css
          position: "fixed"
          margin: 0
          top: (if top > 0 then top else 0) + "px"
          left: (if left > 0 then left else 0) + "px"

    # return this to make this class chainable
    return this

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

  enableSVGfallback: () =>
    # Modernizr SVG backup
    unless Modernizr.svg
      $("img[src*=\"svg\"]").attr "src", ->
        $(this).attr("src").replace ".svg", ".png"


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
      Math.random()*(max-min)+min
    else
      Math.floor(Math.random()*(max-min)+min)


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