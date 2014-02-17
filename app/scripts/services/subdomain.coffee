'use strict'

angular.module('suApp')
  .service 'Subdomain', (Restangular) ->
    (subdomain) ->
      Restangular.withConfig (RestangularConfigurer) ->
        sudbomainUrl = 'https://domain.raterpro.com'.replace 'domain', subdomain
        RestangularConfigurer.setBaseUrl sudbomainUrl