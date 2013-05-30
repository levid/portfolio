#### ImageGrid class
#
# @extends UI
#
# - This class extends the Portfolio.UI class
#
class ImageGrid extends Portfolio.UI

  #### The constructor for the ImageGrid class
  #
  # @param [Object] options
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (@options) ->
    # Extend default options to include passed in arguments
    @options = $.extend({}, this.opts, @options)

    $.subscribe('resize.Portfolio', @initAfterViewContentLoadedProxy('resize.Portfolio'))

    # return this to make this class chainable
    this

  initAfterViewContentLoadedProxy: () ->
    # Skip the first argument (event object) but log the other args.
    (_, options) =>
      @resizeTo = setTimeout(=>
        @buildGrid options, =>
          $('.thumbnails').isotope('reLayout')
          clearTimeout @resizeTo
      , 500)

  buildGrid: (options, callback) ->
    callback          = callback or ->
    if options
      widthDifference = options.widthDifference
      rightMargin     = options.rightMargin
      path            = $UI.Constants?.actionPath
    else
      widthDifference = 0
      rightMargin     = 70

    calc = () =>
      @containerEl    = $('.thumbnails')
      @thumbContainer = $('.thumb')
      windowWidth     = $(window).width() - widthDifference
      windowHeight    = $(window).height()
      containerWidth  = windowWidth - rightMargin
      cols1           = containerWidth
      cols2           = containerWidth / 2
      cols3           = containerWidth / 3

      # console.log "cols1: #{cols1} - cols2: #{cols2} - cols3: #{cols3}"

      if cols2 > 600
        cols = cols3
      else if cols2 < 400
        cols = cols1
      else
        cols = cols2

      @containerEl.css width: $(window).width()
      if @containerEl.find('.thumb').length is 1
        @thumbContainer.css width: containerWidth - 0.5
        @thumbContainer.find('img').css width: containerWidth - 0.5
      else if @containerEl.find('.thumb').length is 2 or path is 'show'
        @thumbContainer.css width: (containerWidth / 2)
        @thumbContainer.find('img').css width: (containerWidth / 2)
      else
        @thumbContainer.css width: cols - 0.5
        @thumbContainer.find('img').css width: cols - 0.5

      @containerEl.imagesLoaded =>
        @containerEl.isotope
          itemSelector: '.thumb'
          animationEngine: 'best-available'
          layoutMode: 'masonry'
          resizeContainer: true
          resizable: true
          transformsEnabled: true
          animationOptions:
           duration: 500
           easing: 'easeInOutQuint'
           queue: false

        # $(@containerEl).show()

      # $.extend $.Isotope::,
      #   _customModeReset: ->
      #   _customModeLayout: ($elems) ->
      #   _customModeGetContainerSize: ->
      #   _customModeResizeChanged: ->
      #     console.log "TEST"
      #     # callback()

    $(window).resize ->
      calc()
    calc()

# Assign this class to the Portfolio Namespace
Portfolio.UI.ImageGrid = ImageGrid