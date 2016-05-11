co = require 'co'
error = require './error'

operations = {

}

global.LAMBDA_MODULE.exports = {
  handler: (event, context) ->
    co ->

    .then context.succeed, context.fail
}
