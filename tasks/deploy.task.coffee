fs = require 'fs'
path = require 'path'
{exec} = require 'child_process'

# debug = require 'gulp-debug'

AWS = require 'aws-sdk'

zip = require 'gulp-zip'
lambda = require 'gulp-awslambda'
chmod = require 'gulp-chmod'

gulp = require 'gulp'

gulp.task 'deploy:webpack', (callback) ->
  config = require '../config'
  deploy = (error) ->
    if error
      console.log "#{error}\n#{error?.stack}"
      return callback error
    (gulp.series 'deploy:npm') callback
  packer = webpack optionsWebpack
  if options.debug
    packer.watch 100, deploy
  else
    packer.run deploy
gulp.task 'deploy:npm', (callback) ->
  /^(aws-sdk|imagemagick)$/.test

  unless options?.projectPath then throw new Error 'projectPath not passed in to options.'
  {gulp, webpack} = options
  unless gulp? then throw new Error 'gulp not passed in to options.'
  unless webpack? then throw new Error 'webpack not passed in to options.'
  pack = require path.join options.projectPath, '/package.json'
  unless pack?.name then throw new Error 'package.json has no name...'
  lambdas = []
  for name in fs.readdirSync path.join options.projectPath, '/lambda'
    do (name) ->
      optionsWebpack = require path.join options.projectPath, '/lambda', name, 'webpack.config.coffee'
      optionsLambda = Object.assign {}, options.lambda, optionsWebpack.lambda
      FunctionName = optionsLambda.FunctionName ?= "#{pack.name}-#{name}"
      gulp.task "lambda:webpack:#{FunctionName}", (callback) ->
        deploy = (error) ->
          if error
            console.log "#{error}\n#{error?.stack}"
            return callback error
          if (key for own key of optionsWebpack.externals when key isnt 'aws-sdk').length
            gulp.series("lambda:npm:#{FunctionName}", "lambda:deploy:#{FunctionName}") callback
          else
            gulp.series("lambda:deploy:#{FunctionName}") callback
        packer = webpack optionsWebpack
        if options.debug
          packer.watch 100, deploy
        else
          packer.run deploy
      gulp.task "lambda:npm:#{FunctionName}", (callback) ->
        exec "npm update", {
          cwd: path.join options.projectPath, 'build/lambda', name
        }, callback
      gulp.task "lambda:deploy:#{FunctionName}", ->#(callback) ->
        # unless options.deploy then return callback()
        unless options?.credentials?.deploy then throw new Error 'AWS config not passed in to options.'
        AWS.config.update options?.credentials?.deploy
        console.log "#{path.join options.projectPath, 'build/lambda', name}/**/*"
        gulp.src "#{path.join options.projectPath, 'build/lambda', name}/**/*"
          # .pipe debug title: 'lambding'
          .pipe chmod read: yes, execute: yes
          .pipe zip "#{FunctionName}.zip"
          .pipe lambda optionsLambda
          # .pipe gulp.dest './'
      gulp.task "lambda:#{FunctionName}", gulp.series "lambda:webpack:#{FunctionName}"
      lambdas.push "lambda:webpack:#{FunctionName}"
  gulp.task 'lambda', gulp.parallel lambdas...

# if test/html you will need: $input.path('$')
