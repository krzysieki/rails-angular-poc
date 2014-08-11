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

  console.log 'test1'

  $urlRouterProvider.otherwise('/main')
])

######################
# i18n configuration #
######################
.config(['$translateProvider', ($translateProvider) ->
  $translateProvider.useStaticFilesLoader(prefix: 'i18n/locale-', suffix: '.json')
  $translateProvider.preferredLanguage('en_US');
])



