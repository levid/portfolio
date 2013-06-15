'use strict'

/**
* The application file bootstraps the angular app by  initializing the main module and
* creating namespaces and moduled for controllers, filters, services, and directives.
*/

var Application = Application || {};

Application.Constants     = angular.module('application.constants', []);
Application.Services      = angular.module('application.services', []);
Application.Controllers   = angular.module('application.controllers', []);
Application.Filters       = angular.module('application.filters', []);
Application.Directives    = angular.module('application.directives', []);

angular.module('application',
  ['ngResource',
  'application.filters',
  'application.services',
  'application.directives',
  'application.constants',
  'application.controllers']
).config(
  ['$routeProvider',
  '$locationProvider',
  '$httpProvider',
  function($routeProvider, $locationProvider, $httpProvider) {
    // $locationProvider.html5Mode(true).hashPrefix('!')
    // $httpProvider.defaults.headers.get['X-Portfolio-Request'] = 'TEST'
    $routeProvider.
      when('/', {
        redirectTo: '/home'
      }).
      when('/home', {
        templateUrl: 'views/home.html',
        controller: 'HomeController',
        customParams: {
          action: 'index'
        }
      }).
      when('/work', {
        templateUrl: 'views/work/index.html',
        controller: 'ProjectsController',
        customParams: {
          action: 'index'
        }
      }).
      when('/work/all', {
        templateUrl: 'views/work/index.html',
        controller: 'ProjectsController',
        customParams: {
          action: 'index',
          category: 'all'
        }
      }).
      when('/work/all/project/:slug', {
        templateUrl: 'views/work/show.html',
        controller: 'ProjectsController',
        customParams: {
          action: 'show',
          category: 'all'
        }
      }).
      when('/work/design', {
        templateUrl: 'views/work/index.html',
        controller: 'ProjectsController',
        customParams: {
          action: 'index',
          category: 'design'
        }
      }).
      when('/work/design/project/:slug', {
        templateUrl: 'views/work/show.html',
        controller: 'ProjectsController',
        customParams: {
          action: 'show',
          category: 'design'
        }
      }).
      when('/work/identity', {
        templateUrl: 'views/work/index.html',
        controller: 'ProjectsController',
        customParams: {
          action: 'index',
          category: 'identity'
        }
      }).
      when('/work/identity/project/:slug', {
        templateUrl: 'views/work/show.html',
        controller: 'ProjectsController',
        customParams: {
          action: 'show',
          category: 'identity'
        }
      }).
      when('/work/code', {
        templateUrl: 'views/work/index.html',
        controller: 'ProjectsController',
        customParams: {
          action: 'index',
          category: 'code'
        }
      }).
      when('/work/code/project/:slug', {
        templateUrl: 'views/work/show.html',
        controller: 'ProjectsController',
        customParams: {
          action: 'show',
          category: 'code'
        }
      }).
      when('/work/web', {
        templateUrl: 'views/work/index.html',
        controller: 'ProjectsController',
        customParams: {
          action: 'index',
          category: 'web'
        }
      }).
      when('/work/web/project/:slug', {
        templateUrl: 'views/work/show.html',
        controller: 'ProjectsController',
        customParams: {
          action: 'show',
          category: 'web'
        }
      }).
      when('/about', {
        templateUrl: 'views/about.html',
        controller: 'AboutController',
        customParams: {
          action: 'index'
        }
      }).
      when('/contact', {
        templateUrl: 'views/contact.html',
        controller: 'ContactController',
        customParams: {
          action: 'index'
        }
      }).
      when('/clients', {
        templateUrl: 'views/clients.html',
        controller: 'ClientsController',
        customParams: {
          action: 'index'
        }
      }).
      when('/cv', {
        templateUrl: 'views/cv.html',
        controller: 'AboutController',
        customParams: {
          action: 'index'
        }
      }).
      when('/themes', {
        templateUrl: 'views/themes.html',
        controller: 'ThemesController',
        customParams: {
          action: 'index'
        }
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
      });
    }
  ]
).run(
  ['$rootScope',
  '$route',
  function($rootScope, $route){
    $rootScope.$on('$routeChangeStart', function(nextRoute, currentRoute) {
      $UI.showLoadingScreen();
      $UI.Constants.viewLoaded = false;
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
}]);