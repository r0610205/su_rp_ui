'use strict'

describe 'Service: Subdomain', () ->

  # load the service's module
  beforeEach module 'suApp'

  # instantiate service
  Subdomain = {}
  beforeEach inject (_Subdomain_) ->
    Subdomain = _Subdomain_

  it 'should do something', () ->
    expect(!!Subdomain).toBe true
