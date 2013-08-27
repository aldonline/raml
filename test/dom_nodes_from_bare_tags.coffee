chai = require 'chai'
should = chai.should()

R = require './R'

describe 'bare tags ( ran outside of any context )', ->
  it 'should parse tags and return the first DOMNode in the block', ->
    node = 'div'._()
    should.exist node
    node.nodeName.should.equal 'DIV'

  it 'should parse nested tags as well', ->
    node = 'div'._ -> 'div'._()
    should.exist node
    node.nodeName.should.equal 'DIV'
    node.hasChildNodes().should.equal yes
    node.childNodes.should.have.length 1
    
    node = node.childNodes[0]
    node.tagName.should.equal 'DIV'