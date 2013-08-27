B = require './bind'

module.exports = ( $elm, props ) ->
  reverts = ( process $elm, k, v for own k, v of props )
  -> r() for r in reverts

process = ( $elm, key, value ) ->
  for k, processor of binders when 0 is key.indexOf k
    if key.length isnt k.length
      key = key[ k.length .. ]
      processor() $elm, key, value
  



p /^value|val$/,       B.value

p /^html$/,            B.html

p /^on([\w]+)$/,       B.event

p /^[\.]([\w\-]+)$/,   B.classflag

p /^[\$]([\w\-]+)$/,   B.style

p /^([\w]+)$/,         B.attr


for p in processors
  if ( r = p.re.exec k )?






syncify = require 'syncify'

bind_attr  = ( $elm, k, v ) ->
  if is_input($elm) and k is 'type'
    # input.type cannot be set if elm is already in the DOM
    if typeof v is 'function'
      throw new Error 'input.type attribute must be set as a fixed value'
    $elm.attr 'type', v
    ( -> ) # cannot undo
  else
    bind_x 'attr', $elm, k, v

bind_classflag = ( $elm, classname, v ) ->
  old = $elm.hasClass classname
  toggle = (v) -> $elm.toggleClass classname, v
  if typeof v is 'function'
    ccl = syncify v, ( err, res ) -> toggle res
  else
    toggle v
  ->
    ccl?()
    toggle old


bind_x = ( x ) -> ( $elm, k, v ) ->
  old = $elm[x] k
  if typeof v is 'function'
    ccl = syncify v, ( err, res ) -> $elm[x] k, res
  else
    $elm[x] k, v # this is throwing an error for type=text
  ->
    ccl?()
    $elm[x] k, old

bind_style = bind_x 'css'
bind_attr = bind_x 'attr'


bind_html = ( $elm, v ) ->
  old = $elm.html()
  if typeof v is 'function'
    ccl = syncify v, ( err, res ) -> $elm.html res
  else
    $elm.html v
  ->
    ccl?()
    $elm.html old


bind_rw_func = ( $elm, rw_func ) -> bidibind $elm, rw_func, rw_func

bidibind = ( $elm, get, set ) ->
  # TODO: this is extremely naive : jQuery val() + interval cas
  # use proper events/streams
  getv = -> $elm.val()
  setv = (v) -> $elm.val v
  if is_checkbox $elm
    getv = -> $elm.prop 'checked'
    setv = (v) -> $elm.prop 'checked', v
  setv last_value = get()
  sync = ->
    if ( v = get() ) isnt last_value
      setv last_value = v
    else if ( v = getv() ) isnt last_value
      set last_value = v
  i = setInterval sync, 200
  ( -> clearInterval i )



bind_event =  (e, k, v) -> e.on k, v ; -> e.off k, v

module.exports =
  attr:       bind_attr
  style:      bind_style
  classflag:  bind_classflag
  html:       bind_html
  val:        bind_val






# KLUDGE
is_input = ( $elm ) -> $elm.prop('tagName').toLowerCase() is 'input'
is_checkbox = ( $elm ) ->  is_input($elm) and $elm.attr('type') is 'checkbox'





