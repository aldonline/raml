chai = require 'chai'
chai.should()
rcell = require 'reactive-cell'

R = require './R'

describe 'when removing a Text Node', ->
  it 'should work', ->
    name = rcell()
    node = 'div'._ ->
      name()
      '_text'._ 'Hello'
    node.nodeName.should.equal 'DIV'

    f = -> name 'Bob'
    
    f.should.not.throw()    