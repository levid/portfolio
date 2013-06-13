'use strict'
#### Notification class
#
# @extends UI
#
# - This class extends the Portfolio.UI class
#
class Notification extends Portfolio.UI
  opts:
    defaultConfig: undefined

  #### The constructor for the Notification class
  #
  # @param [Object] options
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (@options) ->
    # Extend default options to include passed in arguments
    @options = $.extend({}, this.opts, @options)
    @defaultConfig =
      position: "bottom-right"
      closer: "false"
      group: "loaded"
      easing: "swing"
      sticky: "false"
      life: 1500
      animateOpen:
        opacity: "show"
      animateClosed:
        opacity: "hide"
      log: (e, m, o) =>
        # Optional logging mechanism

    # $.subscribe('initAfterViewContentLoaded.Portfolio', @initAfterViewContentLoadedProxy('initAfterViewContentLoaded.Portfolio'))
    $.subscribe('event.Portfolio', @eventHandler('event.Portfolio'))

    # return this to make this class chainable
    return this

  initAfterViewContentLoadedProxy: () ->
    # Skip the first argument (event object) but log the other args.
    (_, path) =>
      @displayNotification
        message: "Viewing #{path}"

  eventHandler: () ->
    # Skip the first argument (event object) but log the other args.
    (_, e) =>
      @displayNotification(e)

  displayNotification: (e) ->
    message     = e.message
    options     = e.options or @defaultConfig
    type        = e.type or 'general'
    statusCode  = e.statusCode or '200' # OK

    # https://github.com/stanlemon/jGrowl
    $.jGrowl message, options

# Assign this class to the Portfolio Namespace
Portfolio.UI.Notification = new Notification()