chai = require 'chai'
chai.should()

R = require './R'

describe 'raml.nodes', ->
  it 'should compile: div --> <div/>', ->
    res = R.nodes -> 'div'._()
    res.should.have.length 1
    node = res[0]
    node.nodeName.should.equal 'DIV'

  it 'should compile: div ; div --> [<div/>, <div/>]', ->
    x = ->
      'div'._()
      'div'._()
    res = R.nodes x
    res.should.have.length 2
    node = res[0]
    res[0].nodeName.should.equal 'DIV'     
    res[1].nodeName.should.equal 'DIV' 

  it 'should compile: div ; p --> [<div/>, <p/>]', ->
    x = ->
      'div'._()
      'p'._()
    res = R.nodes x
    res.should.have.length 2
    node = res[0]
    res[0].nodeName.should.equal 'DIV'     
    res[1].nodeName.should.equal 'P'