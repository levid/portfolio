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

  #### The constructor for the Theme class
  #
  # @param [Object] options
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (@options) ->
    # Extend default options to include passed in arguments
    @options            = $.extend({}, this.opts, @options)
    @themeContainerEL   = @options.themeContainerEl or $(".theme-container")
    @overlayEl          = @options.overlayEl or $("#overlay")
    @wrapper            = @options.wrapper or $("#wrapper")
    @toggleButtonEl     = @options.toggleButtonEl or "[data-behavior='toggle-theme']"

    # return this to make this class chainable
    this

  enableThemes: () ->
    $(document).on('click', @toggleButtonEl, (e) =>
      e.preventDefault()
      themes              = @themeContainerEL.find('li')
      rand                = $UI.Utils.getRandomNumberBetween(0, themes.length)
      backgroundImage     = @themeContainerEL.find("li.active img").data('background')
      backgroundPosition  = @themeContainerEL.find("li.active img").data('position') or 'bottom left'

      @themeContainerEL.find('li').removeClass 'active'
      @themeContainerEL.find("li:eq(#{rand})").addClass 'active'

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

        @wrapper.css(
          "background-image": "url(#{backgroundImage})"
          "background-position": backgroundPosition
        )

        @wrapper.imagesLoaded(=>
          @overlayEl.fadeOut()
        )

        # setTimeout (=>
        # ), 500
      )
    )

# Assign this class to the Portfolio Namespace
Portfolio.UI.Theme = Theme