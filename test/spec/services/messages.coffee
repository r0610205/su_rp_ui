'use strict'

describe 'Service: Messages', () ->

  # load the service's module
  beforeEach module 'suApp'

  # instantiate service
  Messages = {}
  beforeEach inject (_Messages_) ->
    Messages = _Messages_

  it 'should do something', () ->
    expect(!!Messages).toBe true
