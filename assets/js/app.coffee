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

    Portfolio.initAfterViewContentLoaded = => @initAfterViewContentLoaded
    Portfolio.showLoadingScreen = => @showLoadingScreen
    Portfolio.showLoadingSpinner = => @showLoadingSpinner
    Portfolio.hideLoadingSpinner = => @hideLoadingSpinner

    $(document).ready =>
      # @showLoadingScreen()
      @enableAudio()
      @initShareButtons()
      @enableLargeRollovers()
      @enableSmallRollovers()
      @enableThemes()

      $UI.initGlobalUI()

      @sidebar = new $UI.Sidebar(
        sidebarNavEl:    "nav.sidebar-nav"
        sidebarNavLinks: "nav.sidebar-nav ul.nav li a"
      )

      $('section.content .innerContent').css
        minHeight: $(document).innerHeight()

    $(window).load =>

      @hideLoadingScreen()
      @initIsotope()

      # Modernizr SVG backup
      unless Modernizr.svg
        $("img[src*=\"svg\"]").attr "src", ->
          $(this).attr("src").replace ".svg", ".png"

    this



  initIsotope: (callback) ->
    callback = callback or ->

    calc = () =>
      container       = $('.thumbnails')
      margin          = 70
      windowWidth     = $(window).width()
      windowHeight    = $(window).height()
      containerWidth  = windowWidth - margin
      cols1           = containerWidth
      cols2           = containerWidth / 2
      cols3           = containerWidth / 3

      if cols2 > 600
        cols = cols3
      else if cols2 < 300
        cols = cols1
      else
        cols = cols2

      container.css width: containerWidth
      if container.find('.thumb').length is 1
        $(".thumb, .thumb img").css width: containerWidth - 0.5
      else if container.find('.thumb').length is 2
        $(".thumb, .thumb img").css width: (containerWidth / 2)
      else
        $(".thumb").css width: cols - 0.5

      container.imagesLoaded(->
        container.isotope
          itemSelector: '.thumb'
          animationEngine: 'jquery'
          layoutMode: 'masonry'

        callback()
      )

    $(window).resize ->
      calc()
    calc()

  showLoadingScreen: () ->
    $("#overlay").show()
    @showSpinner $('#overlay .spinner'),
      lines: 15
      length: 0
      width: 3
      radius: 50
      color: '#000000'
      speed: 1.6
      trail: 45
      shadow: false
      hwaccel: true

  hideLoadingScreen: () ->
    $("#overlay").fadeOut()
    @hideSpinner $('#overlay .spinner')

  showLoadingSpinner: (target) ->
    $('#loading').fadeIn()
    @showSpinner $('#loading .spinner'),
      lines: 12
      length: 0
      width: 5
      radius: 30
      color: '#ffffff'
      speed: 1.6
      trail: 45
      shadow: false
      hwaccel: false

  hideLoadingSpinner: () ->
    $('#loading').fadeOut(=>
      @hideSpinner $('#loading .spinner')
    )

  initShareButtons: () ->
    $(document).on('mouseenter', '.made-with a', (e) ->
      # $(this).shuffleLetters
      #   callback: ->

      $(this).parents('p').find('a').each (index) ->
        $(this).css
          opacity: 0.6
      $(this).css
        opacity: 1

    ).on('mouseleave', '.made-with a', (e) ->
      $(this).parents('p').find('a').each (index) ->
        $(this).css
          opacity: 1
    )

  enableLargeRollovers: () ->
    $(document).on('mouseenter', 'section.content ul.nav li:not(.filter-by) a', (e) ->
      $(this).shuffleLetters
        callback: ->
          # console.log "finished"
    )

    $(document).on('mouseenter', 'ul.nav li.large a', (e) ->
      ypos      = ($(this).parent().position().top) - ($('.lens-flare').height() / 2)
      highlight = $(this).data('target')
      lenseFlare = $('.lens-flare')
      lenseFlare.css(top: ypos + 86).fadeIn(100)

      $(this).parent().stop().animate
        left: 0
      ,
        duration: 500
        easing: 'easeOutQuint'

      $(this).parents('ul').find('li.large a').each (index) ->
        $(this).css opacity: 0.6
      $(this).css opacity: 1

      $('nav.sidebar-nav .nav li').each (index) ->
        if $(this).attr('class') is highlight
          $(this).find('a').addClass 'highlight'

    ).on('mouseleave', 'ul.nav li.large a',  (e) ->
      $('.lens-flare').hide()
      $(this).parents('ul').find('li.large a').each (index) ->
        $(this).css
          opacity: 1
      $('nav.sidebar-nav .nav li a').removeClass 'highlight'

    ).on('click', 'ul.nav li.large a',  (e) ->
      $('nav.sidebar-nav .nav li a').removeClass 'highlight'
    )

    $(document).on('mouseenter', 'ul.nav li.filter-by a', (e) ->
      $('nav.sidebar-nav .nav li').each (index) ->
        if $(this).attr('class') is 'design' or $(this).attr('class') is 'identity' or $(this).attr('class') is 'code' or $(this).attr('class') is 'web'
          $(this).find('a').addClass 'highlight'

    ).on('mouseleave', 'ul.nav li.filter-by a', (e) ->
      $('nav.sidebar-nav .nav li a').removeClass 'highlight'

    ).on('click', 'ul.nav li.filter-by a', (e) ->
      $('nav.sidebar-nav .nav li a').removeClass 'highlight'
    )

  enableSmallRollovers: () ->
    $(document).on('mouseenter', 'ul.nav li.small a', (e) ->
      highlight = $(this).data('target')
      $(this).parents('ul').find('li.small a').each (index) ->
        $(this).css opacity: 0.6
      $(this).css opacity: 1

      $('nav.sidebar-nav .nav li').each (index) ->
        if $(this).attr('class') is highlight
          $(this).find('a').addClass 'highlight'

    ).on('mouseleave', 'ul.nav li.small a', (e) ->
      $(this).parents('ul').find('li.small a').each (index) ->
        $(this).css
          opacity: 1
      $('nav.sidebar-nav .nav li a').removeClass 'highlight'

    ).on('click', 'ul.nav li.small a', (e) ->
      $('nav.sidebar-nav .nav li a').removeClass 'highlight'
    )

  enableAudio: () ->
    # loop each menu item
    # only clone if more than one needed
    # save reference
    $('nav.sidebar-nav ul.nav li a').each((i) ->
      $("#whoosh").clone().attr("id", "whoosh-" + i).appendTo $("#audio-container")  unless i is 0
      $(this).data "whoosh", i
    )

    $(document).on('mouseenter', 'nav.sidebar-nav ul.nav li a', (e) ->
      $("#whoosh-" + $(this).data("whoosh"))[0].play()
    )
    $("#whoosh").attr "id", "whoosh-0" # get first one into naming convention


    # loop each menu item
    # only clone if more than one needed
    # save reference
    $('.social-links a').each((i) ->
      $("#click").clone().attr("id", "click-" + i).appendTo $("#audio-container")  unless i is 0
      $(this).data "click", i
    )

    $(document).on('mouseenter', '.social-links a', (e) ->
      $("#click-" + $(this).data("click"))[0].play()
    )
    $("#click").attr "id", "click-0" # get first one into naming convention


  enableThemes: () ->
    $(document).on('click', "[data-behavior='toggle-theme']", (e) =>
      e.preventDefault()
      themes = $('.theme-container li')
      rand = @getRandomNumberBetween(0, themes.length)
      backgroundImage = $(".theme-container li.active img").data('background')
      backgroundPosition = $(".theme-container li.active img").data('position') or 'bottom left'

      $(".theme-container li").removeClass 'active'
      $(".theme-container li:eq(#{rand})").addClass 'active'

      $("#overlay").fadeIn(=>
        @showSpinner $('#overlay .spinner'),
          lines: 15
          length: 0
          width: 3
          radius: 50
          color: '#000000'
          speed: 1.6
          trail: 45
          shadow: false
          hwaccel: true

        $("#wrapper").css(
          "background-image": "url(#{backgroundImage})"
          "background-position": backgroundPosition
        )



        $('#wrapper').imagesLoaded(->
          $("#overlay").fadeOut()
        )

        # setTimeout (=>
        #   $("#overlay").fadeOut()
        # ), 500
      )
    )

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

  showSpinner: (target, opts) ->
    opts = opts or
      lines: 12         # The number of lines to draw
      length: 0         # The length of each line
      width: 2          # The line thickness
      radius: 36        # The radius of the inner circle
      color: '#ffffff'  # #rgb or #rrggbb
      speed: 1.6        # Rounds per second
      trail: 45         # Afterglow percentage
      shadow: false     # Whether to render a shadow
      hwaccel: false    # Whether to use hardware acceleration

    $(target).spin(opts)

  hideSpinner: (target) ->
    $(target).spin('stop')

  zoomOut: () ->
    console.log "zoom out"
    $("#loading-block").css
      top: -150
      left: -150
      width: $(window).width() + 300
      height: $(window).height() + 300

    $("#loading-block").animate
      width: $("#loading-block .spinner").width()
      height: $("#loading-block .spinner").height()
      left: ($(window).width() / 2) - ($("#loading-block .spinner").width() / 2)
      top: ($(window).height() / 2) - ($("#loading-block .spinner").height() / 2) - 40
    ,
      duration: 1500
      easing: 'easeOutSine'
      complete: =>
        console.log "finished"

  initAfterViewContentLoaded: (path) ->
    # loop each menu item
    # only clone if more than one needed
    # save reference
    # Append to "main" DOM element in case view is reloaded
    $('section.content ul.nav li:not(.filter-by) a').each((i) ->
      $("#rollover").clone().attr("id", "rollover-" + i).appendTo $('#audio-container') unless i is 0
      $(this).data "rollover", i
    ).hover((e) ->
      audioEl = $("#rollover-" + $(this).data("rollover"))[0]
      audioEl.play() if audioEl
    )
    $("#rollover").attr "id", "rollover-0" # get first one into naming convention

    # navbarHeight = if $('section.content .innerContent')[0].scrollHeight > $('nav.sidebar-nav').height() then $('section.content .innerContent')[0].scrollHeight else $('nav.sidebar-nav').height()

    setTimeout (=>
      @initIsotope(->
        $('.thumbnails').isotope( 'shuffle' )
      )
    ), 500

    $.publish('initAfterViewContentLoaded.Portfolio', path)

    # $(window).resize =>
    #   # $('nav.sidebar-nav').css height: navbarHeight
    #   $('.thumbnails').isotope( 'reLayout' )

    # # $('nav.sidebar-nav').css height: navbarHeight




window.Portfolio = new Portfolio()
