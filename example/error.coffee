###
# Example:
error = require './error'
# ...
error 'my:error:type', new Error 'This message is an error message'
###
module.exports = (type, error) ->
  # Properly set the errorType of the error for the lambda result
  error.name = type
  throw error
