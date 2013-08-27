###
Conditionally find jquery from different places depending on 
whether we are on the client or on the server
###
module.exports = do ->
  if window?
    # browser side. we expect jQuery to be loaded globally
    unless window.jQuery?
      throw new Error 'RAML depends on jQuery'
    window.jQuery
  else
    # server side ( when running tests )
    # we expect jquery to be present in node_modules
    # we rename the require() function so browserify does not
    # follow it when packaging the distribution
    f = require
    f 'jquery'