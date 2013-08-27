htmltagparser  = require 'htmltagparser'
collector = do require 'collector'

arrc = ( arr ) -> Array::slice.apply arr

assert_tag = ( tag, args ) ->
  tags = ( x.trim() for x in tag.split ' ' when x isnt '' )  
  assert_tags tags, args

assert_tags = ( tags, args ) ->
  if tags.length is 1
    collector Tag.factory tags[0], args
  else # recursion
    t = tags.concat()
    assert_tags [t.shift()], [ -> assert_tags t, args ]


class Tag
  @factory: ( tag, args ) ->
    tag = tag.toLowerCase()
    switch tag
      when '_text' then new TextTag args
      when '_insert' then new InsertionTag args
      else new ElementTag tag, args

class InsertionTag extends Tag
  constructor: ( args ) ->
    @content = args[0]

class TextTag extends Tag
  constructor: ( args ) ->
    @content = args[0]

class ElementTag extends Tag
  constructor: ( tag, args ) ->
    # 1. tag, id, classes come first
    @tag = htmltagparser tag, no
    args = args.concat()

    # 2. optional content comes last. can be a function, string or number
    @content = args.pop() if typeof args[-1..][0] in CONTENT_TYPES

    # 3. the rest are parameters
    @events = {}
    @attrs  = {}
    @styles = {}
    @classflags = {}
    @special = {}

    for arg in args when typeof arg is 'object'
      for own k, v of arg
        if k.indexOf('on') is 0 then k = '!' + k[2..]
        if k in ['content', '_content' ] then @content        = v # you can also pass content as a param
        else if k[0] is '$' then @styles[k[1..]] = v # $background-color or $backgroundColor
        else if k[0] is '!' then @events[k[1..]] = v # !click=...
        else if k[0] is '.' then @classflags[k[1..]] = v # .active=true|false        
        else if k[0] is '_' then @special[k[1..]] = v # _bind, _html, _ref, ...
        else                     @attrs[k]       = v # and HTML attributetype=...


CONTENT_TYPES = ['function', 'string', 'number']


module.exports = { assert_tag, collector, Tag, InsertionTag, ElementTag, TextTag }

