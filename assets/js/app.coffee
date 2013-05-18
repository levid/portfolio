class Portfolio
  opts:
    locked: false
    clone: undefined

  #### The constructor for the Portfolio class
  #
  # @param [Object] options
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (@options) ->
    # Extend default options to include passed in arguments
    @options = $.extend({}, this.opts, @options)

    Portfolio.initAfterViewContentLoaded = => @initAfterViewContentLoaded

    $(window).load =>
      # Modernizr SVG backup
      unless Modernizr.svg
        $("img[src*=\"svg\"]").attr "src", ->
          $(this).attr("src").replace ".svg", ".png"

      @enableAudio()
      @initSidebar()
      @initShareButtons()
      @enableLargeRollovers()
      @enableSmallRollovers()
      @enableLockToggle()
      @enableThemes()

    $(window).resize =>
        $('nav.sidebar-nav').css height: $(document).height()
      $('nav.sidebar-nav').css height: $(document).height()


  initSidebar: () ->
    $(document).on('mouseenter', "nav.sidebar-nav ul.nav li a", (e) =>
      ypos = $(e.target).parents('li').find('a').position().top
      text = $(e.target).parents('li').find('.text').text().replace(/\s+/g, "")
      @clone = $('.hover-caption').clone().prependTo('main')
      @clone.text(text)

      if $(e.target).parents('li').find('a').attr('class') is 'active' then @clone.addClass 'active'

      @clone.css(
        top: ypos
      ).stop().animate(
        left: 76
        opacity: 1
      ,
        duration: 200
        easing: 'easeOutQuint'
      )

    ).on('mouseleave', "nav.sidebar-nav ul.nav li a", (e) =>
      @clone.fadeOut('slow').remove() if @clone
    )

    $(document).on('mouseenter', 'nav.sidebar-nav', (e) =>
      if @options.locked is false
        $('.home-nav').stop().animate
          left: "0px"
        ,
          duration: 500
          easing: 'easeOutQuint'

        $(e.target).parents('nav').stop().animate
          left: "0px"
        ,
          duration: 500
          easing: 'easeOutQuint'
          complete: () =>

        $('.lock').fadeIn()

    ).on('mouseleave', 'nav.sidebar-nav', (e) =>
      if @options.locked is false
        $('.home-nav').stop().animate
          left: "-40px"
        ,
          duration: 500
          easing: 'easeOutQuint'

        $(e.target).parents('nav').stop().animate
          left: "-55px"
        ,
          duration: 500
          easing: 'easeOutQuint'
          complete: =>

        $('.lock').fadeOut()
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
        $(this).css
          opacity: 0.6
      $(this).css
        opacity: 1

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
      $("#whoosh").clone().attr("id", "whoosh-" + i).appendTo $(this).parent()  unless i is 0
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
      $("#click").clone().attr("id", "click-" + i).appendTo $(this).parent()  unless i is 0
      $(this).data "click", i
    )

    $(document).on('mouseenter', '.social-links a', (e) ->
      $("#click-" + $(this).data("click"))[0].play()
    )
    $("#click").attr "id", "click-0" # get first one into naming convention


  enableLockToggle: () ->
    $(document).on('click', "[data-behavior='toggle-lock']", (e) =>
      e.preventDefault()
      $(e.target).parents('a').toggleClass 'active'
      if @options.locked is true
        @options.locked = false
      else
        @options.locked= true
    )

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

        setTimeout (=>
          $("#overlay").fadeOut()
        ), 500
      )
    )

  initAfterViewContentLoaded: () ->
    # loop each menu item
    # only clone if more than one needed
    # save reference
    # Append to "main" DOM element in case view is reloaded
    $('section.content ul.nav li:not(.filter-by) a').each((i) ->
      $("#rollover").clone().attr("id", "rollover-" + i).appendTo $('main') unless i is 0
      $(this).data "rollover", i
    ).hover((e) ->
      $("#rollover-" + $(this).data("rollover"))[0].play()
    )
    $("#rollover").attr "id", "rollover-0" # get first one into naming convention


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
    opts = opts ||
      lines: 12 # The number of lines to draw
      length: 0 # The length of each line
      width: 2 # The line thickness
      radius: 36 # The radius of the inner circle
      color: '#000000' # #rgb or #rrggbb
      speed: 1.6 # Rounds per second
      trail: 45 # Afterglow percentage
      shadow: false # Whether to render a shadow
      hwaccel: false # Whether to use hardware acceleration

    $(target).spin(opts)


window.portfolio = new Portfolio()

$.fn.spin = (opts) ->
  @each ->
    $this = $(this)
    data = $this.data()
    if data.spinner
      data.spinner.stop()
      delete data.spinner
    if opts isnt false
      data.spinner = new Spinner($.extend(
        color: $this.css("color")
      , opts)).spin(this)
  this
