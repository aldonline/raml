chai = require 'chai'
chai.should()

cell = require 'reactive-cell'
R = require './R'

# http://www.w3schools.com/jsref/dom_obj_node.asp
describe 'raml.nodes', ->
  it 'should compile an anchor tag with an href attribute', ->
    c = cell()
    c '#'

    res = R.nodes -> 'a'._ href: c
    res.should.have.length 1
    node = res[0]
    node.nodeName.should.equal 'A'
    node.getAttribute('href').should.equal '#'
    c '#f'
    node.getAttribute('href').should.equal '#f'
    c '#g'
    node.getAttribute('href').should.equal '#g'