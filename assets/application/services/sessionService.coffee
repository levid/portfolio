"use strict"

Application.Services.service("sessionService", ["ngResource"]).factory "SessionService", ["$resource", ($resource) ->
  getUser = ->
    _user

  authorized = ->
    _user.authorized is true

  unauthorized = ->
    _user.authorized is false

  login = (newUser, resultHandler, errorHandler) ->
    service.login newUser, ((res) ->
      _user = (res.user or {})
      _user.authorized = res.authorized
      resultHandler res  if angular.isFunction(resultHandler)
    ), (err) ->
      errorHandler err  if angular.isFunction(errorHandler)

  logout = (user, resultHandler, errorHandler) ->
    service.logout user, ((res) ->
      _user = (res.user or {})
      _user.authorized = res.authorized
      resultHandler res  if angular.isFunction(resultHandler)
    ), (err) ->
      errorHandler err  if angular.isFunction(errorHandler)

  service = $resource("/session/:param", {},
    login:
      method: "POST"

    logout:
      method: "DELETE"
  )
  _user = authorized: false
  login: login
  logout: logout
  authorized: authorized
  getUser: getUser

]