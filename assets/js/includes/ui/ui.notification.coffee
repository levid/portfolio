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
    scope:         undefined

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

    @scope = MainCtrl.getScope()
    @enableScopeBinding()

    $.subscribe('event.Portfolio', @eventHandler('event.Portfolio'))

    # return this to make this class chainable
    return this

  enableScopeBinding: () ->
    @scope.$watch 'notifications', (val) =>
      if val is true then @notificationState().on() else @notificationState().off()

  areNotificationsEnabled: () ->
    return @scope.notifications

  notificationState: () ->
    on: () =>
      $.publish 'event.Portfolio', message: "Notifications enabled"

    off: () =>
      $.publish 'event.Portfolio', message: "Notifications disabled"

  eventHandler: () ->
    # Skip the first argument (event object) but log the other args.
    (_, e) =>
      @displayNotification(e)

  displayNotification: (e) ->
    if @areNotificationsEnabled() is true
      message     = e.message
      options     = e.options or @defaultConfig
      type        = e.type or 'general'
      statusCode  = e.statusCode or '200' # OK

      # https://github.com/stanlemon/jGrowl
      $.jGrowl message, options

# Assign this class to the Portfolio Namespace
Portfolio.UI.Notification = Notification