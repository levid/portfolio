#### Audio class
#
# @extends UI
#
# - This class extends the Portfolio.UI class
#
class Audio extends Portfolio.UI
  opts:
    config:             undefined
    audioEnabled:       undefined
    audioContainerEl:   undefined

  #### The constructor for the Audio class
  #
  # @param [Object] options
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (@options) ->
    # Extend default options to include passed in arguments
    @options            = $.extend({}, this.opts, @options)
    @config             = @options.config           or {}
    @audioEnabled       = @options.audioEnabled     or false
    @audioContainerEl   = @options.audioContainerEl or "#audio-container"

    $.subscribe('initAfterViewContentLoaded.Portfolio', @initAfterViewContentLoadedProxy('initAfterViewContentLoaded.Portfolio'))

    # return this to make this class chainable
    this

  initAfterViewContentLoadedProxy: () ->
    # Skip the first argument (event object) but log the other args.
    (_, path) =>
      @enableAudio()

  enableAudio: () ->
    @audioEnabled = true
    @assignSounds()
    # @enableLargeRollovers()

  disableAudio: () ->
    @audioEnabled = false

  assignSounds: () ->
    if @audioEnabled is true
      self = this
      $.each @config, (k,v) =>
        # loop each menu item
        # only clone if more than one needed
        # save reference
        $(v.links).each((i) ->
          $("##{v.soundId}").clone().attr("id", "#{v.soundId}-" + i).appendTo(self.audioContainerEl) unless i is 0
          $(this).data "#{v.soundId}", i
        ).hover((e) ->
          $("##{v.soundId}-" + $(this).data("#{v.soundId}"))[0].play()
        )
        $("##{v.soundId}").attr "id", "#{v.soundId}-0" # get first one into naming convention

# Assign this class to the Portfolio Namespace
Portfolio.UI.Audio = Audio