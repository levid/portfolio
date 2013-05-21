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

  #### The constructor for the Theme class
  #
  # @param [Object] options
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (@options) ->
    # Extend default options to include passed in arguments
    @options            = $.extend({}, this.opts, @options)
    @themeContainerEL   = @options.themeContainerEl or $(".theme-container")
    @overlayEl          = @options.overlayEl        or $("#overlay")
    @wrapper            = @options.wrapper          or $("#wrapper")
    @toggleButtonEl     = @options.toggleButtonEl   or "[data-behavior='toggle-theme']"
    @previewSpinnerEl   = @options.previewSpinnerEl or $(".theme-container .loading")
    # return this to make this class chainable
    this

  getNewTheme: () ->
    rand = () =>
      $UI.Utils.getRandomNumberBetween(0, themes.length)

    themes   = @themeContainerEL.find('li')
    active   = @themeContainerEL.find('li.active').index()
    newTheme = rand()
    newtheme = if newTheme isnt active then newTheme else rand()

    console.log "new: " + newTheme + " | prev: " + active
    newTheme

  changeTheme: (options) ->
    options = options or {}
    theme = @getNewTheme()
    if options.overlay is "false"
      @themeContainerEL.find('li').removeClass 'active'
      @themeContainerEL.find("li:eq(#{theme})").addClass 'active'
      @swapBackgroundImage(theme)
      @swapPreviewImage()
    else
      @showOverlay(theme)

  swapBackgroundImage: () ->
    backgroundImage    = @themeContainerEL.find("li.active img").data('background')
    backgroundPosition = @themeContainerEL.find("li.active img").data('position') or 'bottom left'

    @wrapper.css
      backgroundImage:    "url(#{backgroundImage})"
      backgroundPosition: backgroundPosition

  swapPreviewImage: () ->
    newTheme = @getNewTheme()
    @themeContainerEL.find('li').removeClass 'active'
    @themeContainerEL.find("li:eq(#{newTheme})").addClass 'active'

  showOverlay: (theme) ->
    @overlayEl.fadeIn(=>
      $UI.showSpinner @overlayEl.find('.spinner'),
        lines: 15
        length: 0
        width: 3
        radius: 50
        color: '#000000'
        speed: 1.6
        trail: 45
        shadow: false
        hwaccel: true

      @swapBackgroundImage(theme)
      @swapPreviewImage()
      @previewSpinnerEl.hide()
      $(@toggleButtonEl).find('.text').show()

      @wrapper.imagesLoaded(=>
        @overlayEl.fadeOut()


      )
    )

  enableThemes: () ->
    @changeTheme
      overlay: "false"

    @themeContainerEL.fadeIn('slow')

    $UI.showSpinner @previewSpinnerEl.find('.spinner'),
      lines: 12
      length: 0
      width: 5
      radius: 15
      color: '#ffffff'
      speed: 1.6
      trail: 45
      shadow: false
      hwaccel: false


    $(document).on('click', @toggleButtonEl, (e) =>
      e.preventDefault()
      $(@toggleButtonEl).find('.text').hide()
      @previewSpinnerEl.show()
      @changeTheme()
    )

# Assign this class to the Portfolio Namespace
Portfolio.UI.Theme = Theme