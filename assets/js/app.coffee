class Portfolio
  constructor: () ->
    locked = false

    #### Get random number between two values
    #
    # @param [Integer] min
    # - The minimum number that can be returned
    #
    # @param [Integer] mac
    # - The maximum number that can be returned
    #
    getRandomNumberBetween = (min, max, float) ->
      if float?
        Math.random()*(max-min)+min
      else
        Math.floor(Math.random()*(max-min)+min)


    showSpinner = (target, opts) ->
      opts = opts ||
        lines: 12, # The number of lines to draw
        length: 0, # The length of each line
        width: 2, # The line thickness
        radius: 36, # The radius of the inner circle
        color: '#000000', # #rgb or #rrggbb
        speed: 1.6, # Rounds per second
        trail: 45, # Afterglow percentage
        shadow: false, # Whether to render a shadow
        hwaccel: false # Whether to use hardware acceleration

      $(target).spin(opts)


    # Modernizr SVG backup
    unless Modernizr.svg
      $("img[src*=\"svg\"]").attr "src", ->
        $(this).attr("src").replace ".svg", ".png"

    $(window).resize =>
      $('nav.sidebar-nav').css height: $(document).height()
    $('nav.sidebar-nav').css height: $(document).height()


    $('nav.sidebar-nav ul.nav li a').hover((e) =>
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

    , (e) =>
      @clone.fadeOut('slow').remove() if @clone

    )

    $("nav.sidebar-nav").hover ((e)->
      e.stopPropagation()
      if locked is false
        $('.home-nav').stop().animate
          left: "0px"
        ,
          duration: 500
          easing: 'easeOutQuint'

        $(this).stop().animate
          left: "0px"
        ,
          duration: 500
          easing: 'easeOutQuint'
          complete: =>

        $('.lock').fadeIn()

    ), ->
      if locked is false
        $('.home-nav').stop().animate
          left: "-40px"
        ,
          duration: 500
          easing: 'easeOutQuint'

        $(this).stop().animate
          left: "-55px"
        ,
          duration: 500
          easing: 'easeOutQuint'
          complete: =>

        $('.lock').hide()

    $('section.content ul.nav li:not(.filter-by) a').on('mouseover', (e) ->
      $(this).shuffleLetters
        callback: ->
          # console.log "finished"
    )



    # loop each menu item
    # only clone if more than one needed
    # save reference
    $('nav.sidebar-nav ul.nav li a').each((i) ->
      $("#whoosh").clone().attr("id", "whoosh-" + i).appendTo $(this).parent()  unless i is 0
      $(this).data "whoosh", i
    ).mouseenter ->
      $("#whoosh-" + $(this).data("whoosh"))[0].play()
    $("#whoosh").attr "id", "whoosh-0" # get first one into naming convention


    # loop each menu item
    # only clone if more than one needed
    # save reference
    # Append to "main" DOM element in case view is reloaded
    $('section.content ul.nav li:not(.filter-by) a').each((i) ->
      $("#rollover").clone().attr("id", "rollover-" + i).appendTo $('main')  unless i is 0
      $(this).data "rollover", i
    ).hover(->
      $("#rollover-" + $(this).data("rollover"))[0].play()
    )
    $("#rollover").attr "id", "rollover-0" # get first one into naming convention


    # loop each menu item
    # only clone if more than one needed
    # save reference
    $('.social-links a').each((i) ->
      $("#click").clone().attr("id", "click-" + i).appendTo $(this).parent()  unless i is 0
      $(this).data "click", i
    ).mouseenter ->
      $("#click-" + $(this).data("click"))[0].play()
    $("#click").attr "id", "click-0" # get first one into naming convention



    $("[data-behavior='toggle-theme']").on 'click', (e) ->
      e.preventDefault()
      themes = $('.theme-container li')
      rand = getRandomNumberBetween(0, themes.length)
      backgroundImage = $(".theme-container li.active img").data('background')
      backgroundPosition = $(".theme-container li.active img").data('position') or 'bottom left'

      $(".theme-container li").removeClass 'active'
      $(".theme-container li:eq(#{rand})").addClass 'active'



      $("#overlay").fadeIn(->

        showSpinner $('#overlay .spinner'),
          lines: 15,
          length: 0,
          width: 3,
          radius: 50,
          color: '#000000',
          speed: 1.6,
          trail: 45,
          shadow: false,
          hwaccel: false

        $("#wrapper").css(
          "background-image": "url(#{backgroundImage})"
          "background-position": backgroundPosition
        )

        setTimeout (=>
          $("#overlay").fadeOut()
        ), 500
      )


    $("[data-behavior='toggle-lock']").on 'click', (e) =>
      e.preventDefault()
      $(e.target).parents('a').toggleClass 'active'
      if locked is true
        locked = false
      else
        locked = true

    $('ul.nav li.large a').on('mouseover', (e) ->
      ypos = ($(this).parent().position().top) - ($('.lens-flare').height() / 2)
      # $(this).parent().css left: 200
      highlight = $(this).data('target')
      $('.lens-flare').css(top: ypos + 86).fadeIn(100)

      $(this).parent().stop().animate
        left: 0
      ,
        duration: 500
        easing: 'easeOutQuint'

      $(this).parents('ul').find('li.large a').each (index) ->
        $(this).css
          opacity: 0.6
      $(this).css
        opacity: 1

      $('nav.sidebar-nav .nav li').each (index) ->
        if $(this).attr('class') is highlight
          $(this).find('a').addClass 'highlight'


    ).on('mouseout', (e) ->
      $('.lens-flare').hide()
      $(this).parents('ul').find('li.large a').each (index) ->
        $(this).css
          opacity: 1

      $('nav.sidebar-nav .nav li a').removeClass 'highlight'
    ).on('click', (e) ->
      $('nav.sidebar-nav .nav li a').removeClass 'highlight'
    )

    $('ul.nav li.filter-by a').on('mouseover', (e) ->
      $('nav.sidebar-nav .nav li').each (index) ->
        if $(this).attr('class') is 'design' or $(this).attr('class') is 'identity' or $(this).attr('class') is 'code' or $(this).attr('class') is 'web'
          $(this).find('a').addClass 'highlight'
    ).on('mouseout', (e) ->
      $('nav.sidebar-nav .nav li a').removeClass 'highlight'
    ).on('click', (e) ->
      $('nav.sidebar-nav .nav li a').removeClass 'highlight'
    )


    $('ul.nav li.small a').on('mouseover', (e) ->
      highlight = $(this).data('target')
      $(this).parents('ul').find('li.small a').each (index) ->
        $(this).css
          opacity: 0.6
      $(this).css
        opacity: 1

      $('nav.sidebar-nav .nav li').each (index) ->
        if $(this).attr('class') is highlight
          $(this).find('a').addClass 'highlight'

    ).on('mouseout', (e) ->
      $(this).parents('ul').find('li.small a').each (index) ->
        $(this).css
          opacity: 1
      $('nav.sidebar-nav .nav li a').removeClass 'highlight'
    ).on('click', (e) ->
      $('nav.sidebar-nav .nav li a').removeClass 'highlight'
    )


    $('.made-with a').on('mouseover', (e) ->
      # $(this).shuffleLetters
      #   callback: ->

      $(this).parents('p').find('a').each (index) ->
        $(this).css
          opacity: 0.6
      $(this).css
        opacity: 1

    ).on('mouseout', (e) ->
      $(this).parents('p').find('a').each (index) ->
        $(this).css
          opacity: 1
    )



window.portfolio = Portfolio


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
