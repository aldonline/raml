chai = require 'chai'
should = chai.should()

R = require './R'

###
If children is an array that contains HTMLDomNodes or a jQuery selection ( or an array of jQuery selections - which will be flatmapped ) then they will be added as children.
If children is a function that returns any of the above then they will be used and monitored for reactive changes.

If you don’t return an array, number or string, then the system will use implicit tag declarations.
This means that an array will be built “on the background” for you that takes into account the position of declared tags. This is the most commonly used behaviour.

You can prevent a tag from being attached implicitly by setting the _attach property to false.
###


describe '', ->
  describe 'a simple tag declaration should return a DOMNode', ->
  it '', ->
    elm = 'div'._()

    elm1 = 'div'._ ->
      elm2 = 'div'._()





