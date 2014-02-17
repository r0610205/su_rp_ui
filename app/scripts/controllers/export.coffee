'use strict'

angular.module('suApp')
  .controller 'ExportCtrl', [ 
    '$scope',
    '$location'
    ($scope, $location) ->

      console.log 'main data', $scope.app.suData

      $scope.connection =
        status: $scope.app.messages.connection.inProcess
        established: false
        errors: false
        authorized: false

      projects = $scope.rest().all('projects')

      projects.getList().then (response) ->
        $scope.projects = response.data
        
        _.extend $scope.connection, 
          established: true
          status: $scope.app.messages.connection.verified
      , (reason) ->
        switch reason.status
          when 401
            $location.path('/signin')

        console.log 'errors', reason
        _.extend $scope.connection, 
          status: $scope.app.messages.connection.generalError
          errors: true

  ]
