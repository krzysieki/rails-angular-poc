AppModuleMain.controller('LoginCtrl',  [

  '$scope'
  'Users'

  ($scope, Users) ->

    console.log 'LoginCtrl'

    $scope.model = {}

    $scope.model.user =
      email: 'user@example.com'
      password: 'changeme'
      remember_me: 0

    $scope.submitLoginForm = ->
      Users.login($scope.model)

])