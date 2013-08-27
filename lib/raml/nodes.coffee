bindings         = require './bindings'
tags             = require './tags'
util             = require '../util/util'
$                = require '../util/jquery'
syncify          = require 'syncify'

delay = -> setTimeout arguments[1], arguments[0]

String::_ = ->
  str = String( @ )
  args = Array::slice.apply arguments
  if tags.collector.defined()
    tags.assert_tag str, args.concat()
  else
    ( nodes -> str._.apply str, args )[0]

class Node
  @create: ( tag_data, parent = undefined ) ->
    if tag_data instanceof tags.TextTag
      new TextNode tag_data, parent
    else if tag_data instanceof tags.InsertionTag
      new InsertionNode tag_data, parent
    else if tag_data instanceof tags.ElementTag
      new ElementNode tag_data, parent

  @create_many: ( tag_data_arr, parent = undefined ) ->
    # the instanceof check should be done by the tags module
    # the tags module could be modeled as a combinator over a collector
    @create nd, parent for nd in tag_data_arr when nd instanceof tags.Tag

class InsertionNode extends Node
  constructor: ( @tag_data, @parent = undefined ) ->
    unless @tag_data.content?
      throw new Error 'InsertionNode needs content'
    @parent?.$elm.append @tag_data.content
    @node = $(@tag_data.content)[0]

class TextNode extends Node
  constructor: ( @tag_data, @parent = undefined ) ->
    nd = @tag_data
    document = window?.document or $('body')[0].ownerDocument
    @node = node = document.createTextNode('')
    @parent?.$elm.append node
    switch typeof ( c = nd.content )
      when 'function'
        @cancellators.push syncify c, (err, res) =>
          throw err if err?
          node.nodeValue = String res
      when 'string', 'number' then node.nodeValue = String c

# http://stackoverflow.com/questions/1544317/jquery-change-type-of-input-field
class ElementNode extends Node
  constructor: (  @tag_data, @parent = undefined ) ->
    @cancellators = []
    nd = @tag_data
    # 1. create jquery element
    {tag, id, classes} = nd.tag
    @$elm = e = $ "<#{tag}>"
    @node = e[0]
    @$elm.trigger '_aftercreate' # for now all nodes are created on each pass
    e.attr id: id if id?
    e.addClass c for c in classes
    # 2. set attribute, style and event bindings
    # some attributes cannot be changed
    # once we have been added to our parent
    # input type="..." for example
    # we need to find a way to ensure that at least
    # one complete pass of attribute setting is ready
    @cancellators.push bindings e, nd.attrs, nd.styles, nd.events, nd.classflags, nd.special
    # 3. which is why we only add to parent at the end
    @$elm.trigger '_beforeadd'
    @parent?.$elm.append e 
    @$elm.trigger '_afteradd'
    @children = [] # Node instances
    @raw_children = undefined # an optional jquery selection
    # create children/content
    switch typeof ( c = nd.content )
      when 'function'
        @cancellators.push syncify (tags.collector.attach c), (err, res) =>
          # TODO: Do something smarter with error
          if err?
            console.log err.stack or err
            throw err
          @$elm.trigger '_beforecontentchange'
          @destroy_children()
          if res instanceof Array and res.length > 0 # res is an array
            # that may contain NodeData instances
            # for each tags we create a child Node
            @children.push n for n in Node.create_many res, @
            # and potentially a value at the end
            last = res[res.length - 1] 
            if typeof last is 'string'
              e.text last
            else if last instanceof $
              # jQuery selection
              # TODO: dont use instanceof since we may not
              # be using the same instance of the jquery ( module/library )
              # use a heuristic instead
              @$elm.append @raw_children = last
          @$elm.trigger '_aftercontentchange'
      when 'string', 'number' then e.text c

  destroy_children: ->
    c.destroy() for c in @children
    @children = []
    @raw_children?.remove()
    @raw_children = undefined    

  destroy: ->
    @destroy_children()
    c() for c in @cancellators
    @$elm.trigger '_beforeremove'
    @$elm.remove()
    @$elm.trigger '_afterremove'
    @$elm.trigger '_beforedestroy' # for now all nodes are destroyed
    # GC ettiquette
    delete @cancellators
    delete @parent

collect = ( func ) ->
  result = null
  ccl = syncify tags.collector.attach(func), (err, res) =>
    if err? then throw err
    result = Node.create_many res
  ccl?()
  result

nodes = ( f ) -> x.node for x in collect f

module.exports = nodes