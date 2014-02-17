'use strict'

angular.module('suApp')
  .controller 'SigninCtrl', [ 
    '$scope',
    '$location'    
    ($scope, $location) ->

      $scope.connection =
        status: $scope.app.messages.connection.inProcess
        established: false
        errors: false
        authorized: false

      $scope.connectToAccount = ->
        unless $scope.account
          _.extend $scope.connection, 
            status: $scope.app.messages.connection.noDomain
            errors: true
        else
          $scope.setDomain($scope.account)
          signin = $scope.rest().oneUrl('signin')
          signin.get().then (res) ->
            _.extend $scope.connection, 
              established: true
              status: $scope.app.messages.connection.verified
              errors: false
          , ->
            _.extend $scope.connection, 
              status: $scope.app.messages.connection.generalError
              errors: true

      $scope.signin = ->
        $scope.rest().all('signin').post(user: $scope.user).then -> 
            _.extend $scope.connection,
              established: true,
              status: $scope.app.messages.connection.authorized
            $location.path('/export')
          , ->
            _.extend $scope.connection,
              status: $scope.app.messages.connection.authenticationError

      # Initialize connection status
      $scope.connectToAccount()
  ]
