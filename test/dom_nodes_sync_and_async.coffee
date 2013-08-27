chai = require 'chai'
should = chai.should()

R = require './R'

# pending: we need to change the inner workings
# for the newer modules
# expirator/sync/collector --> reactivity/blocking/collector
describe 'raml.nodes', ->
  it 'return synchronously when no callback is passed', ->
    x = -> 'div'._()
    res = R.nodes x
    should.exist res
    res.should.be.an.instanceOf Array
    res.should.have.length 1
    node = res[0]
    node.nodeName.should.equal 'DIV'