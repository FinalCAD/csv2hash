# Csv2Hash

[![Code Climate](https://codeclimate.com/github/joel/csv2hash.png)](https://codeclimate.com/github/joel/csv2hash)

[![Dependency Status](https://gemnasium.com/joel/csv2hash.png)](https://gemnasium.com/joel/csv2hash)

[![Build Status](https://travis-ci.org/joel/csv2hash.png?branch=master)](https://travis-ci.org/joel/csv2hash) (Travis CI)

[![Coverage Status](https://coveralls.io/repos/joel/csv2hash/badge.png)](https://coveralls.io/r/joel/csv2hash)


It's DSL for valided and map CSV to Ruby Hash

## Installation

Add this line to your application's Gemfile:

    gem 'csv2hash'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install csv2hash

## Usage

#### Rules

You should be declare an definition for you CSV, for each cells you should define what you expect.

Example :

You want first cell parsed should be string with values are 'yes' or 'no' you must fill follow rule :

	{ name: 'aswering', type: 'string', values: ['yes', 'no'], position: [0,0] }

All keys as default value, so you can just define this rule :

	{ name: 'aswering', values: ['yes', 'no'], position: [0,0] }

You can define message, default is 'undefined :key on :position'

	{ name: 'aswering', values: ['yes', 'no'], position: [0,0], message: 'this value is not supported' }

if you insert key on you message they will be substituted

	{ ..., message: 'value of :name is not supported, please you one of :values' }

produce :


	value of aswering is not supported, please you one of [yes, no]

#### Definition

You should provide a definition, you have 2 types of definitions, mapping definition for search on x,y in your data or collection definition for rules apply for all lines in x, so you position rules should be only x value

### Sample

#### Mapping

Consider csv data like that

| Fields      | Person Informations  | Optional |
|-------------|----------------------|----------|
| Nickname    |        john          |    no    |
| First Name  |        John          |    yes   |
| Last Name   |        Doe           |    yes   |


Mapping sample definition

	class MyParser

		attr_accessor :file_path

		def initialize file_path
			@file_path = file_path
		end

		def rules
			[].tap do |mapping|
				mapping << { position: [2,1], key: 'first_name' }
				mapping << { position: [3,1], key: 'last_name' }
			end
		end

		def definition
			Definition.new(rules, type = Definition::MAPPING)
		end

		def data
			Csv2hash.new(definition, file_path).tap do |csv2hash|
				csv2hash.parse
			end.data
		end

	end

#### Collection

Consider csv data like that

| Nickname | First Name | Last Name |
|----------|------------|-----------|
|   john   |    John    |    Doe    |
|   jane   |    Jane    |    Doe    |

Mapping sample definition

	class MyParser

		attr_accessor :file_path

		def initialize file_path
			@file_path = file_path
		end

		def rules
			[].tap do |mapping|
				mapping << { position: 0, key: 'nickname'   }
				mapping << { position: 1, key: 'first_name' }
				mapping << { position: 2, key: 'last_name'  }
			end
		end

		def definition
			Definition.new(rules, type = Definition::COLLECTION)
		end

		def data
			Csv2hash.new(definition, file_path).tap do |csv2hash|
				csv2hash.parse
			end.data
		end

	end

#### Headers

You should be define header size

	Definition.new(rules, type, header_size=0)

#### Default values

only position is require

* :position

all remaind keys are optionals

* message:     'undefined :key on :position'
* mappable:    true
* type:        'string'
* values:      nil
* nested:      nil
* allow_blank: false

### Limitations


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
