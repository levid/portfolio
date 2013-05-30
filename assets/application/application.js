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
      when('/work/design', {
        templateUrl: 'views/work/design.html',
        controller: 'ProjectController',
        customParams: {
          action: 'index',
          category: 'design'
        }
      }).
      when('/work/design/project/:slug', {
        templateUrl: 'views/work/design/show.html',
        controller: 'ProjectController',
        customParams: {
          action: 'show',
          category: 'design'
        }
      }).
      when('/work/identity', {
        templateUrl: 'views/work/identity.html',
        controller: 'WorkController',
        customParams: {
          action: 'index'
        }
      }).
      when('/work/code', {
        templateUrl: 'views/work/code.html',
        controller: 'WorkController',
        customParams: {
          action: 'index'
        }
      }).
      when('/work/web', {
        templateUrl: 'views/work/web.html',
        controller: 'WorkController',
        customParams: {
          action: 'index'
        }
      }).
      when('/work', {
        templateUrl: 'views/work/all.html',
        controller: 'WorkController',
        customParams: {
          action: 'index'
        }
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
        customParams: {
          action: 'index'
        }
      }).
      when('/users/new', {
        templateUrl: 'views/users/new.html',
        controller: 'UsersController.new',
        customParams: {
          action: 'new'
        }
      }).
      when('/users/show/:id', {
        templateUrl: 'views/users/show.html',
        controller: 'UsersController.show',
        customParams: {
          action: 'show'
        }
      }).
      when('/users/edit/:id', {
        templateUrl: 'views/users/edit.html',
        controller: 'UsersController.edit',
        customParams: {
          action: 'edit'
        }
      }).
      when('/users/delete/:id', {
        templateUrl: 'views/users/index.html',
        controller: 'UsersController.delete',
        customParams: {
          action: 'index'
        }
      }).
      otherwise({
        templateUrl: 'views/error404.html'
        // redirectTo: '/login'
      });

  }]).run(function($rootScope, $route){

    $rootScope.$on('$routeChangeStart', function(nextRoute, currentRoute) {
      $UI.showLoadingScreen();
    });
    // Bind the `$routeChangeSuccess` event on the rootScope, so that we dont need to bind in individual controllers.
    $rootScope.$on('$routeChangeSuccess', function(currentRoute, previousRoute) {
      // This will set the custom property that we have defined while configuring the routes.
      if( (typeof $route.current.customParams == "object") && ($route.current.customParams !== null) ){
        $rootScope.customParams = $route.current.customParams;
      }

      // setTimeout((function() {
      //   $UI.hideLoadingScreen();
      // }), 500);
    });
});