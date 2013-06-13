'use strict'

Application.Controllers.controller "ContactController", ["$rootScope", "$scope", "$location", "$socket", "Contact", "SessionService", "$route", "$routeParams", ($rootScope, $scope, $location, $socket, Contact, SessionService, $route, $routeParams) ->

  # AboutController class that is accessible by the window object
  #
  class ContactController

    #### It's always nice to have a constructor to keep things organized
    #
    constructor: () ->
      @initScopedMethods()

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

      $("button.submit").attr('disabled', 'disabled')
      @showLoadingSpinner()

      $.publish 'event.Portfolio', message: "Sending email..."

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

      # str = "http://mail.google.com/mail/?view=cm&fs=1&to=#{to}&su=#{subject}&body=#{newMessage.replace(/\n/g, "%0A")}&ui=1"
      # location.href = str

  window.ContactController = new ContactController()

]