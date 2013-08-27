htmlspec = require 'htmlspec'

tags = do ->
  x = {}
  for own name, tag of htmlspec.tags() then do (name) ->
    x[name] = -> name._.apply name, arguments
  x

tags.export = ( opts = {} ) ->
  { context, uppercase } = opts
  uc = ( tag ) -> if uppercase is yes then tag.toUpperCase() else tag
  context ?= ( global or window )
  context[uc k] = v for own k, v of tags when k isnt 'export'

module.exports = tags