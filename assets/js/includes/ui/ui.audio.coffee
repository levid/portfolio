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

    @initAudioToggleButton()

    $.subscribe('initAfterViewContentLoaded.Portfolio', @initAfterViewContentLoadedProxy('initAfterViewContentLoaded.Portfolio'))

    # return this to make this class chainable
    this

  initAfterViewContentLoadedProxy: () ->
    # Skip the first argument (event object) but log the other args.
    (_, path) =>
      if @audioEnabled is true
        @assignSounds()

  getAudioEnabled: () ->
    return @audioEnabled

  enableAudio: () ->
    @audioEnabled = true
    @assignSounds()

  disableAudio: () ->
    @audioEnabled = false

  initAudioToggleButton: () ->
    $(document).on('click', "[data-behavior='toggle-audio-state']", (e) =>
      e.preventDefault()
      if @audioEnabled is true then @audioState().off() else @audioState().on()
    )

  audioState: () ->
    on: () =>
      $.publish 'event.Portfolio', message: "Audio enabled"
      $("a[data-behavior='toggle-audio-state']").removeClass('off').addClass('on')
      @audioEnabled = true
    off: () =>
      $.publish 'event.Portfolio', message: "Audio disabled"
      $("a[data-behavior='toggle-audio-state']").removeClass('on').addClass('off')
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
        )

        $(document).on 'mouseenter', v.links, (e) ->
          if self.audioEnabled is true
            sound = $("##{v.soundId}-" + $(this).data("#{v.soundId}"))[0]
            sound.play() if sound
        $("##{v.soundId}").attr "id", "#{v.soundId}-0" # get first one into naming convention

  playSound: (target) ->
    $(target)[0].play() if $(target)[0]

# Assign this class to the Portfolio Namespace
Portfolio.UI.Audio = Audio