module.exports =
  delay: ->
    if typeof arguments[0] is 'function'
      setTimeout arguments[0], 300
    else
      setTimeout arguments[1], arguments[0]

  in_browser: -> window?

