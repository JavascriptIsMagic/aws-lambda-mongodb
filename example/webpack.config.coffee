{IgnorePlugin, BannerPlugin} = require 'webpack'
path = require 'path'


module.exports = {
  lambda:
    Description: "Authentication"
    Role: "arn:aws:iam::676646089228:role/lambda-formemail"
    Handler: "server.handler"
    Runtime: "nodejs4.3"
  externals:
    'aws-sdk': 'commonjs aws-sdk'
  devtool: 'sourcemap'
  entry: path.join __dirname, "server.coffee"
  output:
    path: path.join __dirname, "../../build/lambda/#{"#{__dirname}".replace /^(.*[\\\/])*/, ''}"
    filename: "server.js"
  plugins: [
    new BannerPlugin "global.LAMBDA_MODULE = module;", entryOnly: false, raw: true
  ]
  resolve:
    extensions: ['', '.js', '.coffee']
  module:
    loaders: [
      { test: /\.coffee$/, loader: 'coffee' }
    ]
  target: 'node'
  console: no
  global: no
  process: no
  Buffer: no
  __dirname: yes
  __filename: yes
  setImmediate: no
}
