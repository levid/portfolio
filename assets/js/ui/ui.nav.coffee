#### Nav class
#
# @extends UI
#
# - This class extends the Portfolio.UI class
#
class Nav extends Portfolio.UI
  opts:
    sidebarNavEl:     undefined
    sidebarNavLinks:  undefined
    madeWithLinks:    undefined
    homeNavLinks:     undefined
    shuffleLinks:     undefined
    smallNavLinks:    undefined
    allLink:          undefined
    lensFlareEl:      undefined
    lensFlareEnabled: undefined

  #### The constructor for the Nav class
  #
  # @param [Object] options
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (@options) ->
    # Extend default options to include passed in arguments
    @options          = $.extend({}, this.opts, @options)
    @sidebarNavEl     = @options.sidebarNavEl     or "nav.sidebar-nav"
    @sidebarNavLinks  = @options.sidebarNavLinks  or "nav.sidebar-nav ul.nav li a"
    @madeWithLinks    = @options.madeWithLinks    or ".made-with a"
    @homeNavLinks     = @options.homeNavLinks     or "section.content ul.nav li.large a"
    @shuffleLinks     = @options.shuffleLinks     or "section.content ul.nav li:not(.filter-by) a"
    @lensFlareEl      = @options.lensFlareEl      or ".lens-flare"
    @smallNavlinks    = @options.smallNavlinks    or "section.content ul.nav li.small a"
    @allLink          = @options.allLink          or "section.content ul.nav li.filter-by a"
    @lensFlareEnabled = @options.lensFlareEnabled or "true"

    # return this to make this class chainable
    this

  init: () ->
    @initShareButtons()
    @enableRollovers().large()
    @enableRollovers().filterBy()
    @enableRollovers().small()
    @shuffleLetters()

  initShareButtons: () ->
    $(document).on 'mouseenter', '.made-with a', (e) ->
      $(this).parents('p').find('a').each (index) ->
        $(this).css opacity: 0.6
      $(this).css opacity: 1

    $(document).on 'mouseleave', @madeWithLinks, (e) ->
      $(this).parents('p').find('a').each (index) ->
        $(this).css opacity: 1

  shuffleLetters: () ->
    $(document).on('mouseenter', @shuffleLinks, (e) ->
      $(this).shuffleLetters
        callback: ->
          # console.log "finished"
    )

  enableRollovers: () ->
    large: @largeButtons
    filterBy: @filterButton
    small: @smallButtons

  filterNavOpacity: (targetEl, siblings) ->
    $(targetEl).each (index) ->
      $(this).css opacity: 0.6
    $(siblings).css opacity: 1

  lensFlare: (target) ->
    show: () =>
      if @lensFlareEnabled is "true"
        ypos      = ($(target).parent().position().top) - ($(@lensFlareEl).height() / 2)
        highlight = $(target).data('target')
        $(@lensFlareEl).css(top: ypos + 86).fadeIn(100)
    hide: () =>
      if @lensFlareEnabled is "true"
        $(@lensFlareEl).hide()

  hideLensFlare: (target) ->
    if @lensFlareEnabled is "true" then $(@lensFlareEl).hide()

  largeButtons: () =>
    $(document).on('mouseenter', @homeNavLinks, (e) =>
      @lensFlare($(e.target)).show()

      $(e.target).parent().stop().animate
        left: 0
      ,
        duration: 500
        easing: 'easeOutQuint'

      @filterNavOpacity($(e.target).parents('ul').find('li.large a'), $(e.target))
      @highlightLeftNav($(e.target).data('target')).show()

    ).on('mouseleave', @homeNavLinks,  (e) =>
      @lensFlare($(e.target)).hide()

      $(e.target).parents('ul').find('li.large a').each (index) ->
        $(this).css opacity: 1
      @highlightLeftNav().hide()

    ).on('click', @homeNavLinks,  (e) =>
      @highlightLeftNav().hide()
    )

  filterButton: () =>
    $(document).on('mouseenter', @allLink, (e) =>
      @highlightLeftNav('design').show()
      @highlightLeftNav('identity').show()
      @highlightLeftNav('code').show()
      @highlightLeftNav('web').show()

    ).on('mouseleave', @allLink, (e) =>
      @highlightLeftNav().hide()

    ).on('click', @allLink, (e) ->
      @highlightLeftNav().hide()
    )

  smallButtons: () =>
    $(document).on('mouseenter', @smallNavlinks, (e) =>
      @filterNavOpacity($(e.target).parents('ul').find('li.small a'), $(e.target))
      @highlightLeftNav($(e.target).data('target')).show()

    ).on('mouseleave', @smallNavlinks, (e) =>
      $(e.target).parents('ul').find('li.small a').each (index) ->
        $(this).css opacity: 1
      @highlightLeftNav().hide()

    ).on('click', @smallNavlinks, (e) =>
      @highlightLeftNav().hide()
    )

  highlightLeftNav: (target) ->
    highlight = target

    show: () =>
      $(@sidebarNavEl).find('.nav li').each (index) ->
        if $(this).attr('class') is highlight
          $(this).find('a').addClass 'highlight'

    hide: () =>
      $(@sidebarNavEl).find('.nav li a').removeClass 'highlight'

# Assign this class to the Portfolio Namespace
Portfolio.UI.Nav = Nav