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
  opts:
    wrapper:        undefined
    innerContentEl: undefined
    sidebarNavEl:   undefined

  #### The constructor for the Portfolio class
  #
  # @param [Object] options
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (@options) ->
    # Extend default options to include passed in arguments
    @options        = $.extend({}, this.opts, @options)
    @wrapper        = @options.wrapper or "#wrapper"
    @main           = @options.main or "#main"
    @sidebarNavEl   = @options.sidebarNavEl or "nav.sidebar-nav"
    @innerContentEl = @options.innerContentEl or "section.content .innerContent"
    @init()

    this

  init: () ->
    $(document).ready =>
      $UI.Constants.imageGrid = new $UI.ImageGrid()
      $UI.initGlobalUI()

      $(@innerContentEl).css minHeight: $(document).innerHeight()
      $("[data-behavior='scroll-top']").hide()
      $(document).on 'click', "[data-behavior='scroll-top']", (e) =>
        e.preventDefault()
        $UI.scrollTop()

    $(window).resize =>
      $(@innerContentEl).css width: $(window).width()
      $(@innerContentEl).css minHeight: $(document).innerHeight()

    $(window).load =>
      $UI.hideLoadingScreen()
      $UI.Constants.imageGrid.buildGrid()
      $UI.Constants.nav = new $UI.Nav(
        lensFlareEnabled: "true"
      ).init()

      $("[data-behavior='scrollable']").css height: ($(window).height() - 250)
      $(".tooltips").tooltip
        container: 'body'
        placement: 'right'


      $(document).on 'mouseenter', ".user-header .logo a img", (e) ->
        $(this).attr('src', 'images/logo-header-small-light.svg').hide().stop().fadeIn()

      $(document).on 'mouseleave', ".user-header .logo a img", (e) ->
        $(this).attr('src', 'images/logo-header-small.svg').hide().stop().fadeIn()



      # $(document).on 'mouseenter', ".thumbnails .image", (e) ->
      #   e.preventDefault()
      #   $(this).find(".info-container").show()

      # $(document).on 'mouseleave', ".thumbnails .image", (e) ->
      #   e.preventDefault()
      #   $(this).find(".info-container").hide()


    $(@main).on 'scroll', (e) ->
      if $(this).scrollTop() > 100
        $("[data-behavior='scroll-top']").fadeIn()
      else
        $("[data-behavior='scroll-top']").fadeOut()

  initAfterViewContentLoaded: (path) ->
    $UI.scrollTop()

    if path isnt "home"
      $(@wrapper).addClass 'sub'
      $(@main).addClass 'dark'
    else
      $(@wrapper).removeClass 'sub'
      $(@main).removeClass 'dark'

    $(@wrapper).waitForImages (=>
      # if $('.thumbnails').length
      #   $UI.Constants.imageGrid.buildGrid({}, ->
      #     $('.thumbnails').isotope('shuffle')
      #   )
      $.publish('initAfterViewContentLoaded.Portfolio', path)
      $UI.hideLoadingScreen()
      console.log "All images have loaded."

    ),((loaded, count, success) ->
      console.log loaded + " of " + count + " images has " + ((if success then "loaded" else "failed to load")) + "."
      $(this).addClass "loaded"
    ), true

window.Portfolio = new Portfolio()
