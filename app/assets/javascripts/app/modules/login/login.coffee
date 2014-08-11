AppModuleMain = angular.module('app.login', [])

.config [

  '$urlRouterProvider'
  '$stateProvider'

  ($urlRouterProvider, $stateProvider) ->

    $stateProvider
    .state('login',
      url: '/login'
      templateUrl: "app/modules/login/templates/login.html"
      controller: 'LoginCtrl'
    )



  ]