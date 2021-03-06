'use strict'
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
    @wrapper        = @options.wrapper        or $("#wrapper")
    @main           = @options.main           or $("#main")
    @sidebarNavEl   = @options.sidebarNavEl   or $("nav.sidebar-nav")
    @innerContentEl = @options.innerContentEl or $("section.content .innerContent")
    @init()

    return this

  init: () ->
    $(document).ready =>
      $UI.Constants.Settings = {}
      $UI.Constants.imageGrid = new $UI.ImageGrid()
      $UI.Constants.nav       = new $UI.Nav(lensFlareEnabled: "true").init()
      $UI.initGlobalUI()

      $("section.content .innerContent").css minHeight: $(document).innerHeight()

    $(window).resize =>
      $("section.content .innerContent").css width: $(window).width()
      $("section.content .innerContent").css minHeight: $(document).innerHeight()

    $(window).load =>
      $("section.content .innerContent").css width: $(window).width()
      $("[data-behavior='scrollable']").css height: ($(window).height() - 250)

      @initTooltips()
      @initLogoFade()
      @initScrollTop()

      if isMobile.any() then @hideUrlBar()

      # $(document).on 'mouseenter', ".thumbnails .image", (e) ->
      #   e.preventDefault()
      #   $(this).find(".info-container").show()

      # $(document).on 'mouseleave', ".thumbnails .image", (e) ->
      #   e.preventDefault()
      #   $(this).find(".info-container").hide()

   hideUrlBar: () ->
    $(window).load ->
      setTimeout(->
        # Hide the address bar!
        $(window).scrollTo(0, 1)
      , 0)

  initScrollTop: () ->
    $("[data-behavior='scroll-top']").parent().hide()
    $(document).on 'click', "[data-behavior='scroll-top']", (e) ->
      e.preventDefault()
      _gaq.push ['_trackEvent', 'Nav', 'Sidebar', 'Scroll To Top Clicked']
      $UI.scrollTop()

    @main.on 'scroll', (e) ->
      if $(this).scrollTop() > 100
        $("[data-behavior='scroll-top']").parent().fadeIn()
      else
        $("[data-behavior='scroll-top']").parent().fadeOut()

  initLogoFade: () ->
    $(document).on 'mouseenter', ".user-header .logo a img", (e) ->
      $(this).attr('src', 'images/logo-header-small-light.svg').hide().stop().fadeIn()

    $(document).on 'mouseleave', ".user-header .logo a img", (e) ->
      $(this).attr('src', 'images/logo-header-small.svg').hide().stop().fadeIn()

  initTooltips: () ->
    $(".tooltips").tooltip
      container: 'body'
      # placement: 'right'

  initAfterViewContentLoaded: (path) ->
    $UI.scrollTop()
    $UI.Constants.viewLoaded = false

    if path isnt "home"
      @wrapper.addClass 'sub'
      @main.addClass 'dark'
    else
      @wrapper.removeClass 'sub'
      @main.removeClass 'dark'

    $('img:uncached').attr('title', 'Loading...');

    @wrapper.waitForImages (=>
      $UI.Constants.path = path
      $.publish('initAfterViewContentLoaded.Portfolio', path)

      clearTimeout loadedTimeout if loadedTimeout
      loadedTimeout = setTimeout(=>
        $.publish('renderAfterViewContentLoaded.Portfolio', path)
      , 1500)

      log "All images have loaded."
    ),((loaded, count, success) ->
      log loaded + " of " + count + " images has " + ((if success then "loaded" else "failed to load")) + "."
    ), $.noop, true

window.Portfolio = new Portfolio()
