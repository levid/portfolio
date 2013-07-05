'use strict'

Application.Controllers.controller "ContactController", ["$rootScope", "$scope", "$location", "$socket", "Contact", "SessionService", "$route", "$routeParams", ($rootScope, $scope, $location, $socket, Contact, SessionService, $route, $routeParams) ->

  # AboutController class that is accessible by the window object
  #
  class ContactController

    #### It's always nice to have a constructor to keep things organized
    #
    constructor: () ->
      @initScopedMethods()

      if $rootScope.customParams
        if $rootScope.customParams.action == 'index'
          @index($scope, $rootScope.customParams)

      $.subscribe('initAfterViewContentLoaded.Portfolio', @initAfterViewContentLoadedProxy('initAfterViewContentLoaded.Portfolio'))

    initAfterViewContentLoadedProxy: () ->
      # Skip the first argument (event object) but log the other args.
      (_, options) =>
        if $UI.Constants.sidebarMenuOpen is true then Portfolio.openSidebarMenu() else Portfolio.openSidebar()

    #### The index action
    #
    # @param [Object] $scope
    #
    # - The $scope object must be passed in to the method
    #   since it is a public static method
    #
    index: ($scope, params) ->
      $UI.hideLoadingScreen()
      _gaq.push ['_trackEvent', 'Page', 'Viewed', $UI.Constants.path]

    initScopedMethods: () ->
      $scope.contactMe = =>
        @sendEmail($scope.contact)

    sendEmail: (opts) ->
      to = 'i.wooten@gmail.com'
      opts.subject = 'New Portfolio Inquiry'
      opts.newMessage = """
        Name: #{opts.name}
        Email: #{opts.email}
        Phone: #{opts.phone}
        Website: #{opts.website}
        Message: #{opts.message}
      """
      contact = Contact.send(
        body: opts
      , (response) =>
        if response.success is true
          $(".list-container .list:first-child").fadeOut()
          $UI.scrollTop()

        $.publish 'event.Portfolio',
          header: "Response"
          message: response.message

        log response
      )

      $.publish 'event.Portfolio', message: "Sending email..."
      _gaq.push ['_trackEvent', 'Page', 'Contact', 'Email Sent']
      $("button.submit").attr('disabled', 'disabled')
      @showLoadingSpinner()

    showLoadingSpinner: () ->
      $UI.showSpinner $('.list-container .list').find('.spinner'),
        lines: 12
        length: 0
        width: 3
        radius: 8
        color: '#ffffff'
        speed: 1.6
        trail: 45
        shadow: false
        hwaccel: false

  window.ContactController = new ContactController()

]