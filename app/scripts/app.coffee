'use strict';

angular.module('suApp', [
  'restangular',
  'ui.bootstrap',
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute'
])

.config (RestangularProvider, $httpProvider) ->

  $httpProvider.defaults.withCredentials = true
  token = undefined

  RestangularProvider.setBaseUrl('http://gbg.lch.com:3000')
  
  RestangularProvider.addResponseInterceptor (data, operation, what, url, response) ->
    token = response.headers('x-csrf-token');
    if token
      RestangularProvider.setDefaultHttpFields headers: {'X-CSRF-Token': token}
    console.log 'operation', operation
    switch operation
      when 'getList'
        data.items
      else
        data

  RestangularProvider.setMethodOverriders(['put', 'patch'])

  RestangularProvider.setFullResponse(true)
  RestangularProvider.setRequestSuffix('.json')

  # Use Request interceptor
  RestangularProvider.addFullRequestInterceptor (element, operation, route, url, headers) ->
    headers['x-csrf-token'] = token
    return element

  
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


