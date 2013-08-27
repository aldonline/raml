chai = require 'chai'
chai.should()
$ = require 'jquery'

R = require './R'

describe 'raml.nodes', ->
  it 'should allow us to set the inner html ( jquery html() )', -> 
    res = R.nodes -> 'p'._ _html: 'M&amp;A'
    res.should.have.length 1
    node = res[0]
    node.nodeName.should.equal 'P'
    $(node).text().should.equal 'M&A'