chai = require 'chai'
chai.should()

R = require './R'

# http://www.w3schools.com/jsref/dom_obj_node.asp
describe 'raml.nodes', ->
  it 'should compile an anchor tag with an href attribute', ->
    x = -> 'a'._ href: '#'
    res = R.nodes x
    res.should.have.length 1
    node = res[0]
    node.nodeName.should.equal 'A'
    node.getAttribute('href').should.equal '#'