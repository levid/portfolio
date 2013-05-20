'use strict'

/**
* The application file bootstraps the angular app by  initializing the main module and
* creating namespaces and moduled for controllers, filters, services, and directives.
*/

var Application = Application || {};

Application.Constants = angular.module('application.constants', []);
Application.Services = angular.module('application.services', []);
Application.Controllers = angular.module('application.controllers', []);
Application.Filters = angular.module('application.filters', []);
Application.Directives = angular.module('application.directives', []);

angular.module('application', ['ngResource', 'application.filters', 'application.services', 'application.directives', 'application.constants', 'application.controllers']).
  config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {

    // $locationProvider.html5Mode(true).hashPrefix('!')

    $routeProvider.
      when('/', {
        redirectTo: '/home'
      }).
      when('/home', {
        templateUrl: 'views/home.html'
      }).
      when('/design', {
        templateUrl: 'views/design.html',
        controller: 'WorkController'
      }).
      when('/identity', {
        templateUrl: 'views/identity.html',
        controller: 'WorkController'
      }).
      when('/code', {
        templateUrl: 'views/code.html',
        controller: 'WorkController'
      }).
      when('/web', {
        templateUrl: 'views/web.html',
        controller: 'WorkController'
      }).
      when('/all', {
        templateUrl: 'views/all.html',
        controller: 'WorkController'
      }).
      when('/about', {
        templateUrl: 'views/about.html'
      }).
      when('/contact', {
        templateUrl: 'views/contact.html'
      }).
      when('/clients', {
        templateUrl: 'views/clients.html'
      }).
      when('/cv', {
        templateUrl: 'views/cv.html'
      }).
      when('/view1', {
        templateUrl: 'views/partials/partial1.html'
      }).
      when('/view2', {
        templateUrl: 'views/partials/partial2.html'
      }).
      when('/remotepartial', {
        templateUrl: 'template/find/test.html'
      }).
      when('/login',{
        templateUrl: 'views/login.html',
        controller: 'LoginCtrl'
      }).
      when('/logout',{
        templateUrl: 'views/login.html',
        controller: 'LoginCtrl'
      }).
      when('/users', {
        templateUrl: 'views/users/index.html',
        controller: 'UsersController.index',
        action: 'index' // optional action for CRUD methods
      }).
      when('/users/new', {
        templateUrl: 'views/users/new.html',
        controller: 'UsersController.new',
        action: 'new' // optional action for CRUD methods
      }).
      when('/users/show/:id', {
        templateUrl: 'views/users/show.html',
        controller: 'UsersController.show',
        action: 'show' // optional action for CRUD methods
      }).
      when('/users/edit/:id', {
        templateUrl: 'views/users/edit.html',
        controller: 'UsersController.edit',
        action: 'edit' // optional action for CRUD methods
      }).
      when('/users/delete/:id', {
        templateUrl: 'views/users/index.html',
        controller: 'UsersController.delete',
        action: 'delete' // optional action for CRUD methods
      }).
      otherwise({
        templateUrl: 'views/error404.html'
        // redirectTo: '/login'
      });

  }]).run(function($rootScope, $route){

    $rootScope.$on('$routeChangeStart', function(nextRoute, currentRoute) {
      window.portfolio.showLoadingScreen();
    });
    // Bind the `$routeChangeSuccess` event on the rootScope, so that we dont need to bind in individual controllers.
    $rootScope.$on('$routeChangeSuccess', function(currentRoute, previousRoute) {
      // This will set the custom property that we have defined while configuring the routes.
      if($route.current.action && $route.current.action.length > 0){
        $rootScope.action = $route.current.action;
      }

      setTimeout((function() {
        window.portfolio.hideLoadingScreen();
      }), 500);
    });
});