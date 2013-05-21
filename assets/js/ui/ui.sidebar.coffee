#### Sidebar class
#
# @extends UI
#
# - This class extends the Portfolio.UI class
#
class Sidebar extends Portfolio.UI
  opts:
    locked:           undefined
    clone:            undefined
    sidebarNavEl:     undefined
    sidebarNavLinks:  undefined

  #### The constructor for the Sidebar class
  #
  # @param [Object] options
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (@options) ->
    # Extend default options to include passed in arguments
    @options          = $.extend({}, this.opts, @options)
    @locked           = @options.locked or false
    @sidebarNavEl     = @options.sidebarNavEl or "nav.sidebar-nav"
    @sidebarNavLinks  = @options.sidebarNavLinks or "nav.sidebar-nav ul.nav li a"

    @initSidebar()
    @enableToggleButton()

    $UI.Sidebar.initSidebar = => @initSidebar
    $UI.Sidebar.open        = => @open
    $UI.Sidebar.close       = => @close
    $UI.Sidebar.lock        = => @lock
    $UI.Sidebar.unlock      = => @unlock

    $.subscribe('initAfterViewContentLoaded.Portfolio', @initAfterViewContentLoadedProxy('initAfterViewContentLoaded.Portfolio'))

    # return this to make this class chainable
    this

  initAfterViewContentLoadedProxy: (test) ->
    # Skip the first argument (event object) but log the other args.
    (_, path) =>
      if (path.indexOf("work") >= 0)
        @lock()
      else
        @unlock()

  initSidebar: () ->
    $(document).on('mouseenter', @sidebarNavLinks, (e) =>
      ypos = $(e.target).parents('li').find('a').position().top
      text = $(e.target).parents('li').find('.text').text().replace(/\s+/g, "")
      @options.clone = $("[data-object='hover-caption']").clone().prependTo('main')
      @options.clone.text(text)

      if $(e.target).parents('li').find('a').attr('class') is 'active' then @options.clone.addClass 'active'

      @options.clone.css(
        top: ypos
      ).stop().animate(
        left: 76
        opacity: 1
      ,
        duration: 200
        easing: 'easeOutQuint'
      )

    ).on('mouseleave', @sidebarNavLinks, (e) =>
      @options.clone.fadeOut('slow').remove() if @options.clone
    )

    $(document).on('mouseenter', @sidebarNavEl, (e) =>
      @open()

    ).on('mouseleave', @sidebarNavEl, (e) =>
      @close()
    )

  enableToggleButton: () ->
    $(document).on('click', "[data-behavior='toggle-lock']", (e) =>
      e.preventDefault()
      $(e.target).parents('a').toggleClass 'active'
      if @locked is true
        @locked = false
      else
        @locked= true
    )

  open: () ->
    if @locked is false
      $('section.content .innerContent').stop().animate
        left: "0px"
      ,
        duration: 500
        easing: 'easeOutQuint'

      $('nav.sidebar-nav').stop().animate
        left: "0px"
      ,
        duration: 500
        easing: 'easeOutQuint'
        complete: () =>

      $('.lock').fadeIn()

  close: () ->
    if @locked is false
      $('section.content .innerContent').stop().animate
        left: "-50px"
      ,
        duration: 500
        easing: 'easeOutQuint'

      $('nav.sidebar-nav').stop().animate
        left: "-55px"
      ,
        duration: 500
        easing: 'easeOutQuint'
        complete: =>

      $('.lock').fadeOut()

  lock: () ->
    $("a[data-behavior='toggle-lock']").addClass 'active'
    @open()
    @locked = true

  unlock: () ->
    $("a[data-behavior='toggle-lock']").removeClass 'active'
    @locked = false


# Assign this class to the Portfolio Namespace
Portfolio.UI.Sidebar = Sidebar