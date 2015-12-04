#!/usr/bin/env coffee
_ = require 'underscore'
path = require 'path'
fs = require 'fs'
deepmerge = require 'deepmerge'

build = require path.resolve(__dirname,'../package.json')
 
walk = (dir, f_match, f_visit) ->
  _walk = (dir) ->
    for filename in fs.readdirSync dir
      filename = dir + '/' + filename
      f_visit(filename) if f_match filename
      _walk(filename) if fs.statSync(filename).isDirectory()
  _walk(dir, dir)
 
console.log("CoffeeCloud #{build.version}")
console.log("------------------")

matcher = (fn) -> fn.match /\/[^\_][a-zA-Z0-9\_-]+\.coffee$/
matcherCommon = (fn) -> fn.match /\/\_[a-zA-Z0-9\_-]+\.coffee$/

console.log "Loading Helpers..."

helpers = {}
walk(path.resolve(process.cwd(),'helpers'), matcher, (filename) ->
  console.log "- #{path.basename(filename)}"
  helpers = deepmerge(helpers, require(filename) || {})
)

console.log "Loading Common Environment..."

commonenv = {}
walk(path.resolve(process.cwd(),'environments'), matcherCommon, (filename) ->
  console.log "- #{path.basename(filename)}"
  commonenv = deepmerge(commonenv, require(filename) || {})
)

walk(path.resolve(process.cwd(),'environments'),matcher,(envfilename) ->

  templatename = 'build/'+path.basename(envfilename).slice(0,-7)+".template"
  env = deepmerge(commonenv, require(envfilename))
  return unless env.Name?
  console.log("Compiling #{env.Name} environment to #{templatename}...")

  template = {}

  walk(path.resolve(process.cwd(),'cloudformation'), matcher, (filename) ->
    sourceFile = require(filename)
    if sourceFile.CloudFormation?
      console.log "- #{sourceFile.Name}"
      template = deepmerge(template, sourceFile.CloudFormation(env, helpers) || {})
  )

  fs.writeFile(path.resolve(process.cwd(),templatename), JSON.stringify(template, null, 2), (err) ->
    console.log("Error: "+err) if err?
  )
)

console.log("Done.")
