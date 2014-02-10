'use strict'

describe 'Controller: ExportCtrl', () ->

  # load the controller's module
  beforeEach module 'suApp'

  ExportCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ExportCtrl = $controller 'ExportCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(!!scope.connection).toBe true
