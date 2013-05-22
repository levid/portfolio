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
    innerContentEl:   undefined

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

    @initSidebar()
    @enableToggleButton()

    $.subscribe('initAfterViewContentLoaded.Portfolio', @initAfterViewContentLoadedProxy('initAfterViewContentLoaded.Portfolio'))

    # return this to make this class chainable
    this

  initAfterViewContentLoadedProxy: () ->
    # Skip the first argument (event object) but log the other args.
    (_, path) =>
      if (path.indexOf("work") >= 0) then @lock() else @unlock()

  initSidebar: () ->
    $(document).on('mouseenter', @sidebarNavLinks, (e) =>
      ypos            = $(e.target).parents('li').find('a').position().top
      text            = $(e.target).parents('li').find('.text').text().replace(/\s+/g, "")
      linkClass       = $(e.target).parents('li').find('a').attr('class')
      @clone          = $("[data-object='hover-caption']").clone().prependTo('main')
      @clone.text(text)

      if linkClass is 'active' then @clone.addClass 'active'

      @clone.css(top: ypos).stop().animate(
        left: 76
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
        $.publish 'event.Portfolio', message: "Sidebar unlocked"
        @unlock()
      else
        $.publish 'event.Portfolio', message: "Sidebar locked"
        @lock()
    )

  open: () ->
    if @locked is false
      $(@innerContentEl).stop().animate
        left: "0px"
      ,
        duration: 500
        easing: 'easeOutQuint'

      $(@sidebarNavEl).stop().animate
        left: "0px"
      ,
        duration: 500
        easing: 'easeOutQuint'
        complete: () =>

      $(@lockEl).fadeIn()

  close: () ->
    if @locked is false
      $(@innerContentEl).stop().animate
        left: "-50px"
      ,
        duration: 500
        easing: 'easeOutQuint'

      $(@sidebarNavEl).stop().animate
        left: "-55px"
      ,
        duration: 500
        easing: 'easeOutQuint'
        complete: =>

      $(@lockEl).fadeOut()

  lock: () ->
    $("a[data-behavior='toggle-lock']").addClass 'active'
    @open()
    @locked = true

  unlock: () ->
    $("a[data-behavior='toggle-lock']").removeClass 'active'
    @open()
    @locked = false

# Assign this class to the Portfolio Namespace
Portfolio.UI.Sidebar = Sidebar