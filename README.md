# CoffeeCloud

CoffeeCloud allows you to write [AWS CloudFormation](https://aws.amazon.com/cloudformation) templates with [Coffeescript](http://coffeescript.org).

**Why would I want to do that?**

* CoffeeScript syntax for objects is less likely to melt your brain.
* Multiple source files that build to one template means you can organise subsystems in directories, and easily reuse common components.
* You can use dynamic templates, for a single AWS topology with multiple environments (DEV, UAT, PROD) where the config changes depending on environment.
* You get to do comments. Just do `# <comment_text>`, well, anywhere you like.

## Installation

Requires `coffee-script` and `nodejs`.

### Linux (Ubuntu)

	apt-get install nodejs npm
	npm install -g coffee-script
	npm install

### MacOSX (Homebrew)

	brew install nodejs
	npm install -g coffee-script
	npm install

## Usage

CoffeeCloud projects are build around coffeescript modules. Please see the [Writing Modules Guide](docs/writing_modules.md) for more.

### Examples

The repository comes with an example project `Test VPN` in the `cloudformation` and `environments` directories. Please delete the contents of these folders for a clean project:

	rm -rf cloudformation/*
	rm -rf environments/*

### Building Templates

`coffee-script` is used as a macro language to build environment templates. Run:

	coffee compile.coffee

Your CloudFormation `*.template` files will be built into the `build/` directory.

The following steps are performed:

* All `.coffee` files in `./environments` are loaded, 
* The environment params are `require`d from each file, and:
	* An environment template is initialized
	* All `.coffee` files in `./cloudformation` are loaded:
	* For each file:
		* The file module is `require`d and `Cloudformation(environment_params)` is called
		* The output is merged with the environment template
	* The environment template is written to the `build/` directory.

	