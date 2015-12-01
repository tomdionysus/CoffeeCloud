_ = require 'underscore'
path = require 'path'
fs = require 'fs'
deepmerge = require 'deepmerge'
 
walk = (dir, f_match, f_visit) ->
  _walk = (dir) ->
    for filename in fs.readdirSync dir
      filename = dir + '/' + filename
      f_visit(filename) if f_match filename
      _walk(filename) if fs.statSync(filename).isDirectory()
  _walk(dir, dir)
 
console.log("CoffeeCloud v1.0.0")
console.log("------------------")

matcher = (fn) -> fn.match /\.coffee/

walk(path.resolve(__dirname,'environments'),matcher,(envfilename) ->

  templatename = 'build/'+path.basename(envfilename).slice(0,-7)+".template"
  env = require(envfilename)
  console.log("Compiling #{env.Name} environment to #{templatename}")

  template =
    AWSTemplateFormatVersion: "2010-09-09"

  walk(path.resolve(__dirname,'cloudformation'), matcher, (filename) ->
    sourceFile = require(filename)
    if sourceFile.CloudFormation?
      console.log "- #{sourceFile.Name}"
      template = deepmerge(template, sourceFile.CloudFormation(env))
  )

  fs.writeFile(path.resolve(__dirname,templatename), JSON.stringify(template, null, 2), (err) ->
    console.log("Error: "+err) if err?
  )
)

console.log("Done.")
