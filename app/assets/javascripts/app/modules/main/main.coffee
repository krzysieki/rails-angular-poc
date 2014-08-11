AppModuleMain = angular.module('app.main', [])

.config [
  '$urlRouterProvider'
  '$stateProvider'

  ($urlRouterProvider, $stateProvider) ->

    $stateProvider
    .state('main',
      url: '/main'
      templateUrl: "app/modules/main/templates/main.html"
      controller: 'MainCtrl'
    )



  ]