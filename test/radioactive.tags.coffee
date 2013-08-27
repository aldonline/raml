chai = require 'chai'
chai.should()
$ = require 'jquery'

R = require './R'

describe 'radioactive.tags', ->
  it 'should contain functions that generate nodes', ->
    node = R.tags.a href:'#'
    node.nodeName.should.equal 'A'
    node.getAttribute('href').should.equal '#'

  it 'should be able to export tag functions to the global space', ->
    R.tags.export()
    node = a href:'#'
    node.nodeName.should.equal 'A'
    node.getAttribute('href').should.equal '#'

  it 'should be able to export tag functions to the global space ( uppercase )', ->
    R.tags.export uppercase: yes
    node = A href:'#'
    node.nodeName.should.equal 'A'
    node.getAttribute('href').should.equal '#'

  it 'should be able to export tag functions to a custom context', ->
    ctx = {}
    R.tags.export context: ctx
    node = ctx.a href:'#'
    node.nodeName.should.equal 'A'
    node.getAttribute('href').should.equal '#'

  it 'should be able to export tag functions to a custom context ( uppercase )', ->
    ctx = {}
    R.tags.export context: ctx, uppercase: yes
    node = ctx.A href:'#'
    node.nodeName.should.equal 'A'
    node.getAttribute('href').should.equal '#'