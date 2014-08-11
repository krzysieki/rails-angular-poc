AppModuleMain = angular.module('app.register', [])

.config [

  '$urlRouterProvider'
  '$stateProvider'

  ($urlRouterProvider, $stateProvider) ->

    $stateProvider
    .state('register',
      url: '/register'
      templateUrl: "app/modules/register/templates/register.html"
      controller: 'RegisterCtrl'
    )

  ]