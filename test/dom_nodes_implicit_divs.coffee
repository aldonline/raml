chai = require 'chai'
chai.should()

R = require './R'

describe 'raml.nodes', ->

  # implicit divs
  it 'should compile:  #foo --> <div id="foo"/>', ->
    x = -> '#foo'._()
    res = R.nodes x
    res.should.have.length 1
    node = res[0]
    node.nodeName.should.equal 'DIV'
    node.getAttribute('id').should.equal 'foo'

  it 'should compile:  #foo.clazz --> <div class="clazz" id="foo"/>', ->
    x = -> '#foo.clazz'._()
    res = R.nodes x
    res.should.have.length 1
    node = res[0]
    node.nodeName.should.equal 'DIV'
    node.getAttribute('id').should.equal 'foo'
    node.getAttribute('class').should.equal 'clazz'

  it 'should compile:  #foo.clazz.clazz2 --> <div class="clazz clazz2" id="foo"/>', ->
    x = -> '#foo.clazz.clazz2'._()
    res = R.nodes x
    res.should.have.length 1
    node = res[0]
    node.nodeName.should.equal 'DIV'
    node.getAttribute('id').should.equal 'foo'
    # is the order of classes guaranteed?
    # lets assume it's not and sort
    node.getAttribute('class').split(' ').sort().join(' ').should.equal('clazz clazz2')