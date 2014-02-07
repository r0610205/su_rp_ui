'use strict'

angular.module('suApp')
  .controller 'ExportCtrl', [ 
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

      projects = Restangular.all('projects')

      projects.getList().then (response) ->
        $scope.projects = response.data
        
        _.extend $scope.connection, 
          established: true
          status: Messages.connection.verified
      , (reason) ->
        switch reason.status
          when 401
            $location.path('/signin')

        console.log 'errors', reason
        _.extend $scope.connection, 
          status: Messages.connection.generalError
          errors: true

  ]
