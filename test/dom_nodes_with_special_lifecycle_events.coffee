chai = require 'chai'
chai.should()

R = require './R'

describe.skip 'raml.nodes', ->
  it 'should compile elements with RAML specific lifecycle events', ->