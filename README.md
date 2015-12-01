# CoffeeCloud

CoffeeCloud allows you to write [AWS CloudFormation]() templates with [Coffeescript](http://coffeescript.org).

**Why would I want to do that?**

In short:

* CoffeeScript syntax for objects is less likely to melt your brain.
* Dynamic templates, for a single AWS topology with multiple environments (DEV, UAT, PROD) where the config changes depending on environment.
* Comments. Just do `# <comment_text>`, well, anywhere you like.

## Installation

Requires `coffee-script` and `nodejs`.

### Linux (Ubuntu)

	apt-get install nodejs
	npm install -g coffee-script
	npm install

### MacOSX (Homebrew)

	brew install nodejs
	npm install -g coffee-script
	npm install

## Usage

### Examples

The repository comes with example config in `cloudformation` and `environments`. Please delete the contents of these folders for a clean project.

### Building Templates

`coffee-script` is used as a macro language to build environment templates. Run:

	coffee compile.coffee

Your CloudFormation `*.template` files will be build into the `build/` directory.

The following steps are performed:

* All `.coffee` files in `./environments` are loaded, 
* The environment params are `require`d from each file, and:
	* An environment template is initialized
	* All `.coffee` files in `./cloudformation` are loaded:
	* For each file:
		* The file module is `require`d and `Cloudformation(environment_params)` is called
		* The output is merged with the environment template
	* The environment template is written to the `build/` directory.

	