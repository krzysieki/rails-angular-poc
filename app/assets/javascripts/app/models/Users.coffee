App.factory 'Users', [
  'Restangular',
  '$cookieStore',
  '$timeout',

  (Restangular, $cookieStore, $timeout) ->

    $notification = {}
    Users = Restangular.one('users')
    Users.username = localStorage.username or ''
    Users.remember = localStorage.remember or false
    Users.session    = $cookieStore.get('session')
    logoutTimeout = 3 # logout timeout after session expiry (sec)

    # LOGIN SERVICE
    # data = {
    #   "username": "string",
    #   "password": "string"
    # }
    Users.login = (data) ->
      Users.post('sign_in', data)
      .then (res) ->

        console.log res
        # STORES DATA IN ANGULAR MODEL
        Users.remember = data.remember
        Users.username = res.username
        Users.session = res.session

        # CREATE COOKIES
        $cookieStore.put('session', Users.session)
        localStorage.username = Users.username

        if Users.remember
          localStorage.remember = true
        else
          delete localStorage.remember

        # ADD RESPONSE HEADER (TO MAINTAIN SESSION)
        Restangular.setFullRequestInterceptor (element, operation, route, url, headers, params) ->
          res =
            headers: _.extend(headers, {'X-Session': Users.session})
            element: element,
            params: params

    Users.sessionExpiry = () ->
      $timeout((() -> $notification.error('Your session has expired, you will be logged out in ' + logoutTimeout + 'sec.')), 0)
      $timeout(Users.reset, logoutTimeout * 1000)

    # Resets user sessiotn and reloads application
    Users.reset = () ->
      $cookieStore.remove('session')
      delete localStorage.username if not Users.remember
      window.location.href = '/' # reload page to reset aplication

    # LOGOUT SERVICE
    Users.logout = () ->
      Users.post('logout', {'username': Users.username})
      .catch (err) ->
        console.log 'logout fail', err
      .finally () =>
        @reset()

    Users
]
