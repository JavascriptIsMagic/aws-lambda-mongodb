# WARNING: Do NOT webpack this file! (Use a completely static config file instead.)
pack = require './package.json'
Config = require 'immutable-config'
# AWS = require 'aws-sdk'

projectConfig = try require "./#{pack.name}.config.coffee"
unless projectConfig?
  console.warn "./#{pack.name}.config.coffee is missing or has not loaded properly."

defaults = {

}

module.exports = Config.empty.merge [
  defaults
  Config.unflattenedEnv
  projectConfig or Config.argvConfig or Config.envConfig or {}
  Config.unflattenedArgv
  { package: pack }
], deep: yes

console.log module.exports
