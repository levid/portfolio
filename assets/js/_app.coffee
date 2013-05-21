#### The Application class serving as the base class
#
# This class can be accessed via ** window.Portfolio **
#
# ** Additional Classes: **
#
# - UI
# - UI.Sidebar
# - UI.Theme
# - UI.Audio
# - UI.Utils
#
class Portfolio
  opts: {}

  #### The constructor for the Portfolio class
  #
  # @param [Object] options
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (@options) ->
    # Extend default options to include passed in arguments
    @options = $.extend({}, this.opts, @options)
    @init()

    this

  init: () ->
    $(document).ready =>
      @imageGrid = new $UI.ImageGrid()
      $UI.initGlobalUI()

      $('section.content .innerContent').css minHeight: $(document).innerHeight()

    $(window).load =>
      $UI.hideLoadingScreen()
      @imageGrid.buildGrid()
      @nav = new $UI.Nav(
        lensFlareEnabled: "true"
      ).init()

  initAfterViewContentLoaded: (path) ->
    # navbarHeight = if $('section.content .innerContent')[0].scrollHeight > $('nav.sidebar-nav').height() then $('section.content .innerContent')[0].scrollHeight else $('nav.sidebar-nav').height()

    setTimeout (=>
      @imageGrid.buildGrid(->
        $('.thumbnails').isotope( 'shuffle' )
      )
    ), 500

    $.publish('initAfterViewContentLoaded.Portfolio', path)

window.Portfolio = new Portfolio()