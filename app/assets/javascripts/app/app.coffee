App = angular.module('app', [
  'ui.router'
  'ngCookies'
  'ngResource'
  'restangular'
  'pascalprecht.translate'

  'app.main'
  'app.login'
  'app.register'
])

#########################
# routing configuration #
#########################
.config(['$urlRouterProvider', ($urlRouterProvider) ->
  $urlRouterProvider.otherwise('/main')
])

######################
# i18n configuration #
######################
.config(['$translateProvider', ($translateProvider) ->
  $translateProvider.useStaticFilesLoader(prefix: 'i18n/locale-', suffix: '.json')
  $translateProvider.preferredLanguage('en_US');
])

.config([
    'RestangularProvider',
    '$locationProvider'

    (RestangularProvider, $locationProvider) ->
      RestangularProvider.setBaseUrl('http://0.0.0.0:3000/api/v1')
      RestangularProvider.setDefaultHeaders
        'Content-Type'  : 'application/json'
        'Accept'        : 'application/json'
        'X-CSRF-Token'    : 'Rrj1VYf0WxOw26K1qYkalGA+6h59sCwLlHX+yPEIbDI='



      $locationProvider.html5Mode(false)
  ])



