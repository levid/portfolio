#### Theme class
#
# @extends UI
#
# - This class extends the Portfolio.UI class
#
class Theme extends Portfolio.UI
  opts:
    themeContainerEl: undefined
    overlayEl:        undefined
    wrapper:          undefined
    toggleButtonEl:   undefined
    previewSpinnerEl: undefined
    enabled:          undefined

  #### The constructor for the Theme class
  #
  # @param [Object] options
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (@options) ->
    # Extend default options to include passed in arguments
    @options            = $.extend({}, this.opts, @options)
    @themeContainerEl   = @options.themeContainerEl or $(".theme-container")
    @overlayEl          = @options.overlayEl        or $("#overlay")
    @wrapper            = @options.wrapper          or $("#wrapper")
    @toggleButtonEl     = @options.toggleButtonEl   or "[data-behavior='toggle-theme']"
    @previewSpinnerEl   = @options.previewSpinnerEl or $(".theme-container .loading")
    @enabled            = false

    $.subscribe('initAfterViewContentLoaded.Portfolio', @initAfterViewContentLoadedProxy('initAfterViewContentLoaded.Portfolio'))

    # return this to make this class chainable
    this

  initAfterViewContentLoadedProxy: () ->
    # Skip the first argument (event object) but log the other args.
    (_, path) =>
      # if path.indexOf("home") >= 0
      @enableThemes() unless @enabled is true
      @themeContainerEl = $(".theme-container")
      @themeContainerEl.fadeIn('slow')

  getRandomTheme: () ->
    themes   = @themeContainerEl.find('li')

    rand = () =>
      $UI.Utils.getRandomNumberBetween(0, themes.length)

    active   = @themeContainerEl.find('li.active').index()
    newTheme = rand()
    newtheme = if newTheme isnt active then newTheme else rand()
    newTheme

  changeVisibleTheme: (options) ->
    options = options or {}
    theme   = @getRandomTheme()
    if options.overlay is "false"
      @themeContainerEl.find('li').removeClass 'active'
      @themeContainerEl.find("li:eq(#{theme})").addClass 'active'
      @swapBackgroundImage()
      @swapPreviewImage()
    else
      @showOverlay(theme)

  swapBackgroundImage: (callback) ->
    callback = callback or ->

    if callback is 'default'
      backgroundImage    = @themeContainerEl.find("li.default img").data('background')
      backgroundPosition = @themeContainerEl.find("li.default img").data('position') or 'bottom left'
    else
      backgroundImage    = @themeContainerEl.find("li.active img").data('background')
      backgroundPosition = @themeContainerEl.find("li.active img").data('position') or 'bottom left'

    if backgroundImage isnt null
      message = backgroundImage.toString().split('/')
      message = message[message.length-1]
      $.publish 'event.Portfolio',
        header: "Current Theme"
        message: message

      @wrapper.css(
        backgroundImage:    "url(#{backgroundImage})"
        backgroundPosition: backgroundPosition
      ).waitForImages (->
        callback() unless callback is 'default'
      ), $.noop, true

  swapPreviewImage: () ->
    newTheme = @getRandomTheme()
    @themeContainerEl.find('li').removeClass 'active'
    @themeContainerEl.find("li:eq(#{newTheme})").addClass 'active'

  showOverlay: (theme) ->
    unless $("#overlay").attr('display') is 'block'
      @overlayEl.fadeIn(=>
        $UI.showSpinner @overlayEl.find('.spinner'),
          lines: 15
          length: 0
          width: 2
          radius: 60
          color: '#000000'
          speed: 1.6
          trail: 45
          shadow: false
          hwaccel: true

        @swapBackgroundImage(=>
          @overlayEl.fadeOut()
          @swapPreviewImage()
          @previewSpinnerEl.hide()
          $(@toggleButtonEl).find('.text').show()
        )
      )

  enableThemes: () ->
    @enabled = true
    @swapPreviewImage()
    $(@themeContainerEl).fadeIn(500)

    is_default = @themeContainerEl.find("li").hasClass('default')
    if is_default isnt false
      @swapBackgroundImage('default')
    else
      @swapBackgroundImage()
      @swapPreviewImage()

    $UI.showSpinner @previewSpinnerEl.find('.spinner'),
      lines: 12
      length: 0
      width: 4
      radius: 15
      color: '#ffffff'
      speed: 1.6
      trail: 45
      shadow: false
      hwaccel: false

    $(document).on('click', "[data-behavior='toggle-theme']", (e) =>
      e.preventDefault()
      $(@toggleButtonEl).find('.text').hide()
      @previewSpinnerEl.show()
      @changeVisibleTheme()
    )

# Assign this class to the Portfolio Namespace
Portfolio.UI.Theme = Theme