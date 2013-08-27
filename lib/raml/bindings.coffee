syncify = require 'syncify'

bind_x = ( x, $elm, k, v ) ->
  old = $elm[x] k
  if typeof v is 'function'
    ccl = syncify v, ( err, res ) -> $elm[x] k, res
  else
    $elm[x] k, v # this is throwing an error for type=text
  ->
    ccl?()
    $elm[x] k, old

bind_style = ( $elm, k, v ) -> bind_x 'css', $elm, k, v

bind_html = ( $elm, v ) ->
  old = $elm.html()
  if typeof v is 'function'
    ccl = syncify v, ( err, res ) -> $elm.html res
  else
    $elm.html v
  ->
    ccl?()
    $elm.html old


bind_special = ( $elm, k, v ) ->
  if k is 'html'
    bind_html $elm, v
  else if k is 'bind'
    bind_entry_or_rw_func $elm, v


bind_attr  = ( $elm, k, v ) ->
  if k is 'bind' # TODO: deprecate "bind" in favor of "_bind"
    bind_entry_or_rw_func $elm, v
  else
    if is_input($elm) and k is 'type'
      # input.type cannot be set if elm is already in the DOM
      if typeof v is 'function'
        throw new Error 'input.type attribute must be set as a fixed value'
      $elm.attr 'type', v
      ( -> ) # cannot undo
    else
      bind_x 'attr', $elm, k, v

bind_event = ( $elm, name, cb ) ->
  $elm.on name, cb
  -> $elm.off name, cb

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


bind_entry_or_rw_func = ( $elm, x ) ->
  if 'function' is typeof x
    bind_rw_func $elm, x
  else
    throw new Error "You can only bind cells"


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


module.exports = bind = ( $elm, attrs, styles, events, classflags, special ) ->
  try
    reverts = []
    reverts.push bind_attr  $elm, k, v for own k, v of attrs
    reverts.push bind_special  $elm, k, v for own k, v of special
    reverts.push bind_style $elm, k, v for own k, v of styles
    reverts.push bind_event $elm, k, v for own k, v of events
    reverts.push bind_classflag $elm, k, v for own k, v of classflags
  catch e
    console.log '[ERROR]'
    console.log e # we are catching these errors upstack for now so we print them here to retain some visibility
    throw e
  ->
    r() for r in reverts

# KLUDGE
is_input = ( $elm ) -> $elm.prop('tagName').toLowerCase() is 'input'
is_checkbox = ( $elm ) ->  is_input($elm) and $elm.attr('type') is 'checkbox'


