###
npm uninstall gulp -g
npm uninstall gulp
npm install --global gulpjs/gulp-cli#4.0
npm install --save-dev gulpjs/gulp.git#4.0 coffee-script yargs
###
require './config'
fs = require 'fs'
path = require 'path'

gulp = require 'gulp'
{version} = require 'gulp/package.json'
unless 4 <= parseFloat version
  throw new Error "Gulp 4+ is required. \n Solution: `npm install --save-dev gulp@next` or `npm install --save-dev gulpjs/gulp#4.0`"

for filename in fs.readdirSync path.join __dirname, 'tasks'
  if /task\..+$/.test filename
    require path.join __dirname, 'tasks', filename
