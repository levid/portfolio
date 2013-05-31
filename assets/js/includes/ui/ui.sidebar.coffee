#### Sidebar class
#
# @extends UI
#
# - This class extends the Portfolio.UI class
#
class Sidebar extends Portfolio.UI
  opts:
    lockEl:           undefined
    settingsEl:       undefined
    locked:           undefined
    clone:            undefined
    sidebarNavEl:     undefined
    sidebarNavLinks:  undefined
    sidebarMenuEl:    undefined
    contentEl:        undefined
    innerContentEl:   undefined
    lensFlareEl:      undefined
    sidebarMenuOpen:  undefined
    hoverCaptionEl:   undefined
    thumbnailsEl:     undefined
    loaded:           undefined

  #### The constructor for the Sidebar class
  #
  # @param [Object] options
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (@options) ->
    # Extend default options to include passed in arguments
    @options          = $.extend({}, this.opts, @options)
    @lockEl           = @options.lockEl           or ".lock"
    @settingsEl       = @options.settingsEl       or ".settings"
    @locked           = @options.locked           or false
    @sidebarNavEl     = @options.sidebarNavEl     or "nav.sidebar-nav"
    @sidebarNavLinks  = @options.sidebarNavLinks  or "nav.sidebar-nav ul.nav li a"
    @sidebarMenuEl    = @options.sidebarMenuEl    or "nav.sidebar-nav .content-menu"
    @innerContentEl   = @options.innerContentEl   or "section.content .innerContent"
    @contentEl        = @options.contentEl        or "section.content"
    @thumbnailsEl     = @options.thumbnailsEl     or "section.content .innerContent .thumbnails"
    @lensFlareEl      = @options.lensFlareEl      or ".lens-flare"
    @hoverCaptionEl   = @options.hoverCaptionEl   or "[data-object='hover-caption']"

    @initSidebar()
    @enableButtons()

    $.subscribe('initAfterViewContentLoaded.Portfolio', @initAfterViewContentLoadedProxy('initAfterViewContentLoaded.Portfolio'))

    # return this to make this class chainable
    this

  initAfterViewContentLoadedProxy: () ->
    # Skip the first argument (event object) but log the other args.
    (_, path) =>
      # @initSidebar()
      @path = path

      @loadedTimeout = setTimeout(=>
        @loaded = true
        @initSidebar()
        clearTimeout @loadedTimeout
      , 500)

  initSidebar: () ->
    $(@hoverCaptionEl).hide()
    # @locked = true
    if @sidebarMenuOpen is true
      # Set initial position of inner content
      $(@innerContentEl).css left: 300
      # open Sidebar menu
      @openSidebarMenu()
    else
      # Set initial position of inner content
      $(@innerContentEl).css left: 70
      # open Sidebar
      @openSidebar()

    @setHeightTimeout = setTimeout(=>
      $('nav.sidebar-nav').css height: $('section.content .innerContent').height() + 120
      clearTimeout @setHeightTimeout
    , 1000)

    $(window).resize =>
      $('nav.sidebar-nav').css height: $('section.content .innerContent').height() + 120

  enableButtons: () ->
    $(document).on 'mouseenter', @sidebarNavLinks, (e) =>
      $(@hoverCaptionEl).show()
      ypos            = $(e.target).parents('li').find('a').position().top
      text            = $(e.target).parents('li').find('.text').text().replace(/\s+/g, "")
      linkClass       = $(e.target).parents('li').find('a').attr('class')
      buttonClass     = $(e.target).parents('li').attr('class')
      @clone          = $("[data-object='hover-caption']").clone().prependTo($(e.target).parents('li'))
      @clone.text(text)

      if linkClass is 'active' then @clone.addClass 'active'
      if buttonClass is 'all'
        @highlightLeftNav('design').show()
        @highlightLeftNav('identity').show()
        @highlightLeftNav('code').show()
        @highlightLeftNav('web').show()
        @highlightLeftNav('all').show()

      @clone.css top: ypos
      @clone.stop().animate(
        left: ($("nav.sidebar-nav").width()) - 222
        opacity: 1
      ,
        duration: 200
        easing: 'easeOutQuint'
      )

    $(document).on 'mouseleave', @sidebarNavLinks, (e) =>
      @clone.fadeOut('slow').remove() if @clone
      @highlightLeftNav().hide()

    $(document).on 'mouseenter', @sidebarNavEl, (e) => if @sidebarMenuOpen isnt true then @openSidebar()
    $(document).on 'mouseleave', @sidebarNavEl, (e) => if @locked isnt true and @sidebarMenuOpen isnt true then @closeSidebar()

    $(document).on 'click', "[data-behavior='toggle-lock']", (e) =>
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

    $(document).on 'click', "[data-behavior='toggle-menu']", (e) =>
      @clone.remove()
      e.preventDefault()

      if $UI.Constants.audio.getAudioEnabled() is true
        $UI.Constants.audio.playSound("#slide")

      if @sidebarMenuOpen is true
        @closeSidebarMenu()
      else if @sidebarMenuOpen is false
        @openSidebarMenu()

  highlightLeftNav: (target) ->
    highlight = target
    showingAll = @path.indexOf("all") >= 0

    show: () =>
      $(@sidebarNavEl).find('.nav li').each (index) ->
        if $(this).attr('class') is highlight
          $(this).find('a').addClass 'highlight' unless showingAll is true

    hide: () =>
      showingAll = @path.indexOf("all") >= 0
      if showingAll is true
        $(@sidebarNavEl).find('.nav li a.active').removeClass('highlight')
      else
        $(@sidebarNavEl).find('.nav li a').removeClass('highlight')

      # $(@sidebarNavEl).find('.nav li a').each (index) ->
      #   if $(this).attr('class') isnt 'highlight'
      #     $(@sidebarNavEl).find('.nav li a').removeClass 'highlight'
      #   else if $(this).attr('class') is 'active'
      #     $(@sidebarNavEl).find('.nav li a').removeClass('highlight')

  openSidebarMenu: () ->
    # console.log "open sidebar menu"
    @sidebarOpen = true
    @sidebarMenuOpen = true

    containerWidth = ($(window).width() - $(@sidebarNavEl).width()) - 16
    $(@contentEl).css width: containerWidth
    $(@innerContentEl).css width: containerWidth
    $(@thumbnailsEl).css width: containerWidth

    @adjustImageGrid(
      options =
        widthDifference: $(@sidebarNavEl).width() - 70
        rightMargin: 70
    )

    $(@lensFlareEl).css left: 310
    $(@lockEl).fadeIn(500).css left: 20
    $(@settingsEl).fadeIn(500).css left: 55

    # $(@sidebarNavEl).removeClass('animate-sidebar-closed')
    # $(@sidebarNavEl).removeClass('animate-sidebar-open')
    # $(@sidebarNavEl).addClass('animate-sidebar-menu-open')

    @animateToPosition @innerContentEl, 300
    @animateToPosition @sidebarNavEl, 0
    @animateToPosition @sidebarMenuEl, 7

  closeSidebarMenu: () ->
    # console.log "close sidebar menu"

    if @locked is true
      @openSidebar()
    else
      @closeSidebar()
    @sidebarOpen = true
    @sidebarMenuOpen = false

  openSidebar: () ->
    # console.log "open sidebar"
    @sidebarOpen = true
    @sidebarMenuOpen = false

    containerWidth = $(window).width() - 70
    $(@contentEl).css width: containerWidth
    $(@innerContentEl).css width: containerWidth
    $(@thumbnailsEl).css width: containerWidth

    @adjustImageGrid(
      options =
        widthDifference: 0
        rightMargin: 70
    )

    # $(@sidebarNavEl).removeClass('animate-sidebar-menu-open')
    # $(@sidebarNavEl).removeClass('animate-sidebar-closed')
    # $(@sidebarNavEl).addClass('animate-sidebar-open')

    $(@lockEl).fadeOut(500, =>
      $(this).css left: -50
    )
    $(@settingsEl).fadeOut(500, =>
      $(this).css left: -50
    )

    $(@hoverCaptionEl).css left: 80
    $(@lensFlareEl).css left: 80
    @animateToPosition @thumbnailsEl, 0
    @animateToPosition @innerContentEl, 70
    @animateToPosition @sidebarNavEl, -230
    @animateToPosition @sidebarMenuEl, -300

  closeSidebar: () ->
    # console.log "close sidebar"
    @sidebarOpen = false
    @sidebarMenuOpen = false

    containerWidth = $(window).width()
    $(@contentEl).css width: containerWidth
    $(@innerContentEl).css width: containerWidth
    $(@thumbnailsEl).css width: containerWidth

    @adjustImageGrid(
      options =
        widthDifference: 0
        rightMargin: 0
    )

    # $(@sidebarNavEl).removeClass('animate-sidebar-menu-open')
    # $(@sidebarNavEl).removeClass('animate-sidebar-open')
    # $(@sidebarNavEl).addClass('animate-sidebar-closed')

    $(@lockEl).fadeOut(500, =>
      $(this).css left: -50
    )
    $(@settingsEl).fadeOut(500, =>
      $(this).css left: -50
    )

    $(@lensFlareEl).css left: 10
    @animateToPosition @thumbnailsEl, 0
    @animateToPosition @innerContentEl, 0
    @animateToPosition @sidebarNavEl, -285
    @animateToPosition @sidebarMenuEl, -300

  adjustImageGrid: (options) ->
    widthDifference  = options.widthDifference or 0
    rightMargin      = options.rightMargin or 0

    if @loaded is true
      $.publish('resize.Portfolio',
        options =
          widthDifference: widthDifference
          rightMargin:     rightMargin
      )

  animateToPosition: (el, pos, callback) ->
    callback = callback or ->
    $(el).stop().animate
      left: pos
    ,
      duration: 500
      easing: 'easeInOutQuint'
      complete: () =>
        callback()

  lock: () ->
    @sidebarMenuOpen = false
    @locked = true
    @openSidebar()

  unlock: () ->
    @sidebarMenuOpen = false
    @locked = false
    @closeSidebar()

# Assign this class to the Portfolio Namespace
Portfolio.UI.Sidebar = Sidebar