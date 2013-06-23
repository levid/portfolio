'use strict'
#### Audio class
#
# @extends UI
#
# - This class extends the Portfolio.UI class
#
class Audio extends Portfolio.UI
  opts:
    config:             undefined
    audioContainerEl:   undefined
    scope:              undefined

  #### The constructor for the Audio class
  #
  # @param [Object] options
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (@options) ->
    # Extend default options to include passed in arguments
    @options            = $.extend({}, this.opts, @options)
    @config             = @options.config           or {}
    @audioContainerEl   = @options.audioContainerEl or "#audio-container"
    @scope              = MainCtrl.getScope()
    @enableScopeBinding()

    $.subscribe('initAfterViewContentLoaded.Portfolio', @initAfterViewContentLoadedProxy('initAfterViewContentLoaded.Portfolio'))

    # return this to make this class chainable
    return this

  initAfterViewContentLoadedProxy: () ->
    # Skip the first argument (event object) but log the other args.
    (_, path) =>
      @assignSounds()

  enableScopeBinding: () ->
    @scope.$watch 'audio', (val) =>
      if val is true then @audioState().on() else @audioState().off()

  isAudioEnabled: () ->
    return @scope.audio

  audioState: () ->
    on: () =>
      @assignSounds()
      $.publish 'event.Portfolio', message: "Sounds enabled"

    off: () =>
      $.publish 'event.Portfolio', message: "Sounds disabled"

  assignSounds: () ->
    if @isAudioEnabled() is true
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
          if self.isAudioEnabled() is true
            sound = $("##{v.soundId}-" + $(this).data("#{v.soundId}"))[0]
            sound.play() if sound
        $("##{v.soundId}").attr "id", "#{v.soundId}-0" # get first one into naming convention

  playSound: (target) ->
    $(target)[0].play() if $(target)[0]

# Assign this class to the Portfolio Namespace
Portfolio.UI.Audio = Audio