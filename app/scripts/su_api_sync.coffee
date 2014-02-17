window.su_api_sync =
  get: () ->
    angular.element(document.body).injector().get('Sudata')