'use strict'

describe 'Service: Sudata', () ->

  # load the service's module
  beforeEach module 'suApp'

  # instantiate service
  Sudata = {}
  beforeEach inject (_Sudata_) ->
    Sudata = _Sudata_

  it 'should do something', () ->
    expect(!!Sudata).toBe true
