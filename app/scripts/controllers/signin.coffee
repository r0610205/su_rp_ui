'use strict'

angular.module('suApp')
  .controller 'SigninCtrl', [ 
    '$scope',
    '$location',
    '$http',
    'Restangular',
    'Messages',
    ($scope, $location, $http, Restangular, Messages) ->

      $scope.connection =
        status: Messages.connection.inProcess
        established: false
        errors: false
        authorized: false

      signin = Restangular.oneUrl('signin')
      signin.get().then (res) ->
        console.log 'get then' ,res
        _.extend $scope.connection, 
          established: true
          status: Messages.connection.verified

      , ->
        _.extend $scope.connection, 
          status: Messages.connection.generalError
          errors: true

      $scope.signin = ->
        Restangular.all('signin').post(user: $scope.user).then -> 
            _.extend $scope.connection,
              established: true,
              status: Messages.connection.authorized
            $location.path('/export')
          , ->
            _.extend $scope.connection,
              status: Messages.connection.authenticationError
  ]
