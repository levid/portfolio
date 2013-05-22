#### Sidebar class
#
# @extends UI
#
# - This class extends the Portfolio.UI class
#
class Sidebar extends Portfolio.UI
  opts:
    lockEl:           undefined
    locked:           undefined
    clone:            undefined
    sidebarNavEl:     undefined
    sidebarNavLinks:  undefined
    contentEl:        undefined
    innerContentEl:   undefined
    lensFlareEl:      undefined
    slideMenuOpen:    undefined

  #### The constructor for the Sidebar class
  #
  # @param [Object] options
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (@options) ->
    # Extend default options to include passed in arguments
    @options          = $.extend({}, this.opts, @options)
    @lockEl           = @options.lockEl           or ".lock"
    @locked           = @options.locked           or false
    @sidebarNavEl     = @options.sidebarNavEl     or "nav.sidebar-nav"
    @sidebarNavLinks  = @options.sidebarNavLinks  or "nav.sidebar-nav ul.nav li a"
    @innerContentEl   = @options.innerContentEl   or "section.content .innerContent"
    @contentEl        = @options.contentEl        or "section.content"
    @lensFlareEl      = @options.lensFlareEl      or ".lens-flare"
    @slideMenuOpen    = false

    @initSidebar()
    @initMenuButton()
    @enableToggleButton()

    $.subscribe('initAfterViewContentLoaded.Portfolio', @initAfterViewContentLoadedProxy('initAfterViewContentLoaded.Portfolio'))

    # return this to make this class chainable
    this

  initAfterViewContentLoadedProxy: () ->
    # Skip the first argument (event object) but log the other args.
    (_, path) =>
      @open()
      # if (path.indexOf("work") >= 0) then @lock() else @unlock()

  initSidebar: () ->
    $(document).on('mouseenter', @sidebarNavLinks, (e) =>
      ypos            = $(e.target).parents('li').find('a').position().top
      text            = $(e.target).parents('li').find('.text').text().replace(/\s+/g, "")
      linkClass       = $(e.target).parents('li').find('a').attr('class')
      @clone          = $("[data-object='hover-caption']").clone().prependTo($(e.target).parents('li'))
      @clone.text(text)

      if linkClass is 'active' then @clone.addClass 'active'
      @clone.css(
        top: ypos
      ).stop().animate(
        left: ($("nav.sidebar-nav").width()) - 222
        opacity: 1
      ,
        duration: 200
        easing: 'easeOutQuint'
      )
    )

    $(document).on 'mouseleave', @sidebarNavLinks, (e) => @clone.fadeOut('slow').remove() if @clone
    $(document).on 'mouseenter', @sidebarNavEl, (e) => @open()
    $(document).on 'mouseleave', @sidebarNavEl, (e) => @close()

  enableToggleButton: () ->
    $(document).on('click', "[data-behavior='toggle-lock']", (e) =>
      e.preventDefault()
      $(e.target).parents('a').toggleClass 'active'

      if @locked is true
        $("a[data-behavior='toggle-lock']").removeClass 'active'
        $.publish 'event.Portfolio', message: "Sidebar unlocked"
        @unlock()
      else if @locked is false
        $("a[data-behavior='toggle-lock']").addClass 'active'
        $.publish 'event.Portfolio', message: "Sidebar locked"
        @lock()
    )

  initMenuButton: () ->
    $(document).on('click', "[data-behavior='toggle-menu']", (e) =>
      @clone.remove()
      e.preventDefault()

      if $UI.Constants.audio.getAudioEnabled() is true
        $UI.Constants.audio.playSound("#slide")

      if @slideMenuOpen is true
        @slideMenuOpen = false
        @open()

        $(@innerContentEl).css width: $(window).width()
        options =
          difference: 0

        $.publish('resize.Portfolio', options)

      else if @slideMenuOpen is false
        $(".hover-caption").css left: '300px'
        $(@lensFlareEl).stop().animate
          left: "0px"
        ,
          duration: 500
          easing: 'easeInOutQuint'

        $(@innerContentEl).stop().animate
          left: "0px"
        ,
          duration: 500
          easing: 'easeInOutQuint'

        $(@sidebarNavEl).stop().animate
          left: "0px"
        ,
          duration: 500
          easing: 'easeInOutQuint'
          complete: () =>

        $(@sidebarNavEl).find('.content-menu').stop().animate
          left: "7px"
          opacity: 1
        ,
          duration: 500
          easing: 'easeInOutQuint'
          complete: () =>

        $(@lockEl).fadeIn('slow').css(
          left: "5px"
        )

        $(@innerContentEl).css width: $(window).width() - $(@sidebarNavEl).width()
        options =
          difference: $(window).width() - $(@innerContentEl).width()
          margin: -1

        $.publish('resize.Portfolio', options)
        @slideMenuOpen = true
    )


  open: () ->
    if @locked is false and @slideMenuOpen is false
      $(@lensFlareEl).stop().animate
        left: "-200px"
      ,
        duration: 500
        easing: 'easeInQuint'

      $(@innerContentEl).find('.thumbnails').stop().animate
        left: "0px"
      ,
        duration: 500
        easing: 'easeInOutQuint'

      $(@innerContentEl).stop().animate
        left: "-230px"
      ,
        duration: 500
        easing: 'easeInOutQuint'

      $(@sidebarNavEl).stop().animate
        left: "-230px"
      ,
        duration: 500
        easing: 'easeInOutQuint'
        complete: () =>

      $(@sidebarNavEl).find('.content-menu').stop().animate
        left: "-300px"
        opacity: 0
      ,
        duration: 500
        easing: 'easeInOutQuint'
        complete: () =>
          $(@lockEl).fadeOut('slow').css(
            left: "-50px"
          )

      $(@innerContentEl).css width: $(window).width()
      options =
        difference: 5
        margin: 0

      $.publish('resize.Portfolio', options)

  close: () ->
    if @locked is false and @slideMenuOpen is false
      $(@lensFlareEl).stop().animate
        left: "-240px"
      ,
        duration: 500
        easing: 'easeInOutQuint'

      $(@innerContentEl).find('.thumbnails').stop().animate
        left: "0px"
      ,
        duration: 500
        easing: 'easeInOutQuint'

      $(@innerContentEl).stop().animate
        left: "-290px"
      ,
        duration: 500
        easing: 'easeInOutQuint'

      $(@sidebarNavEl).stop().animate
        left: "-290px"
      ,
        duration: 500
        easing: 'easeInOutQuint'
        complete: =>
          $(@lockEl).fadeOut('slow').css(
            left: "-50px"
          )

      $(@innerContentEl).css width: $(window).width()
      options =
        difference: 0
        margin: 5

      $.publish('resize.Portfolio', options)


  lock: () ->
    @slideMenuOpen = false
    @open()
    @locked = true

    $(@innerContentEl).css width: $(window).width()
    options =
      difference: 0

    $.publish('resize.Portfolio', options)

  unlock: () ->
    @slideMenuOpen = false
    @locked = false
    @open()

# Assign this class to the Portfolio Namespace
Portfolio.UI.Sidebar = Sidebar