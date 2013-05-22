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
    $("#wrapper").waitForImages (=>
      console.log "All images have loaded."

      $UI.hideLoadingScreen()
      @imageGrid.buildGrid(->
        $('.thumbnails').isotope( 'shuffle' )
      )

      $.publish('initAfterViewContentLoaded.Portfolio', path)
      # $.publish 'event.Portfolio',
      #   type:       "notification"
      #   statusCode: "200"
      #   message:    "All images have loaded."
      #   options:
      #     position: "bottom-right"
      #     closer:   "false"
      #     group:    "success"

    ),((loaded, count, success) ->
      console.log loaded + " of " + count + " images has " + ((if success then "loaded" else "failed to load")) + "."
      $(this).addClass "loaded"

      # $.publish 'event.Portfolio',
      #   type:       "notification"
      #   statusCode: "200"
      #   message:    loaded + " of " + count + " images has " + ((if success then "loaded" else "failed to load")) + "."
      #   options:
      #     position: "bottom-right"
      #     closer:   "false"
      #     group:    "success"

    ), true

window.Portfolio = new Portfolio()
