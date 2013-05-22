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
    # return this to make this class chainable
    this

  buildGrid: (callback) ->
    callback = callback or ->

    calc = () =>
      @containerEl     = $('.thumbnails')
      @thumbContainer  = $('.thumb')
      margin          = 70
      windowWidth     = $(window).width()
      windowHeight    = $(window).height()
      containerWidth  = windowWidth - margin
      cols1           = containerWidth
      cols2           = containerWidth / 2
      cols3           = containerWidth / 3

      cols = if cols2 > 600 then cols3 else if cols2 < 300 then cols1 else cols2

      @containerEl.css width: containerWidth

      if @containerEl.find('.thumb').length is 1
        @thumbContainer.css width: containerWidth - 0.5
        @thumbContainer.find('img').css width: containerWidth - 0.5
      else if @containerEl.find('.thumb').length is 2
        @thumbContainer.css width: (containerWidth / 2)
        @thumbContainer.find('img').css width: (containerWidth / 2)
      else
        @thumbContainer.css width: cols - 0.5

      @containerEl.imagesLoaded(=>
        @containerEl.isotope
          itemSelector: '.thumb'
          animationEngine: 'jquery'
          layoutMode: 'masonry'

        callback()
      )

    $(window).resize ->
      calc()
    calc()




# Assign this class to the Portfolio Namespace
Portfolio.UI.ImageGrid = ImageGrid