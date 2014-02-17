'use strict';

angular.module('suApp', [
  'restangular',
  'ui.bootstrap',
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute'
])

.config (RestangularProvider) ->

  token = undefined
 
  RestangularProvider.setDefaultHttpFields 
    withCredentials: true
  
  RestangularProvider.addResponseInterceptor (data, operation, what, url, response) ->
    token = response.headers('x-csrf-token')
    if token
      RestangularProvider.setDefaultHeaders 'X-CSRF-Token': token

    switch operation
      when 'getList'
        data.items
      else
        data

  RestangularProvider.setMethodOverriders(['put', 'patch'])
  RestangularProvider.setFullResponse(true)
  RestangularProvider.setRequestSuffix('.json')



  
.config ($routeProvider) ->
  $routeProvider
    .when '/signin', 
      templateUrl: 'signin.html',
      controller: 'SigninCtrl'
    .when '/export', 
      templateUrl: 'projects.html',
      controller: 'ExportCtrl'
    
    .otherwise
      redirectTo: '/export'

  
.run ($rootScope, Subdomain, Messages, Utils, suData) ->
  
  _.extend $rootScope,

    app:
      messages: Messages
      utils: Utils
      suData: suData
    rest: ->
      Subdomain(suData.domain)

    setDomain: (subdomain) ->
      suData.domain = subdomain




