###
Some IE love
###
unless 'function' is typeof String::trim then String::trim = -> $.trim @
unless @console?.log? then (@console ?= {}).log ?= -> alert arguments