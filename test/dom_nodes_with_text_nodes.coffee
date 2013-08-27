chai = require 'chai'
chai.should()
$ = require 'jquery'

R = require './R'

# http://www.w3schools.com/jsref/dom_obj_node.asp
describe 'raml.nodes', ->
  it 'should compile nested text nodes', ->
    x = ->
      '_text'._ 'A'
      'a'._ href: '#', 'B'
      '_text'._ 'C'

    res = R.nodes x
    res.should.have.length 3
    p = $('<p>')
    p.append x for x in res
    p.html().should.equal 'A<a href="#">B</a>C'