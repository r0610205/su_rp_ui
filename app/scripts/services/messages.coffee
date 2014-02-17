'use strict'

angular.module('suApp')
  .service 'Messages', () ->
    connection: 
      inProcess: 'Verifying connection to RaterPRO'
      verified: 'Connection Verified'
      noDomain: 'Please, specify account'
      generalError: 'Connection Error'
      authorized: 'Connection Authorized'
      authenticationError: 'Connection Error'
      error: 'Test'
    # AngularJS will instantiate a singleton by calling "new" on this function
