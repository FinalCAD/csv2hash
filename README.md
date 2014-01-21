# Csv2Hash

[![Code Climate](https://codeclimate.com/github/joel/csv2hash.png)](https://codeclimate.com/github/joel/csv2hash)

[![Dependency Status](https://gemnasium.com/joel/csv2hash.png)](https://gemnasium.com/joel/csv2hash)

[![Build Status](https://travis-ci.org/joel/csv2hash.png?branch=master)](https://travis-ci.org/joel/csv2hash) (Travis CI)

[![Coverage Status](https://coveralls.io/repos/joel/csv2hash/badge.png)](https://coveralls.io/r/joel/csv2hash)


It is a DSL to validate and map a CSV to a Ruby Hash.

## Installation

Add this line to your application's Gemfile:

    gem 'csv2hash'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install csv2hash

## Usage

Parsing is based on rules, you must defined rules of parsing

### Rules

You should declare a definition for you CSV, and then define for each cell what you would expect.

Example :

You want the cell located on first line, first column to be a string with its values to be 'yes' or 'no'. Then you can right the following validation rule :

	{ name: 'aswering', type: 'string', values: ['yes', 'no'], position: [0,0] }

The type is 'string' by default, so can just write:

	{ name: 'aswering', values: ['yes', 'no'], position: [0,0] }

You can define a message, default is 'undefined :key on :position'

	{ name: 'aswering', values: ['yes', 'no'], position: [0,0], message: 'this value is not supported' }

You can also define Range

	{ name: 'score', values: 0..5, position: [0,0] }

The message is parsed:

	{ ..., message: 'value of :name is not supported, please you one of :values' }

It produces :

	value of aswering is not supported, please you one of [yes, no]

### Default values

Only position is required:

* :position

All remaining keys are optionals:

* message:     'undefined :key on :position'
* mappable:    true
* type:        'string'
* values:      nil
* nested:      nil
* allow_blank: false
* extra_validator: nil

## Define where your data is expected

**IMPORTANT!** Position mean [Y, X], where Y is rows, X columns

A definition should be provided. There are 2 types of definitions:
* search for data at a precise position in the table: `y,x`
* or search for data in a column of rows, where all the rows are the same: `x` (column index)

## Samples

### Validation of a cell at a precise position

Consider the following CSV:

| Fields      | Person Informations  | Optional |
|-------------|----------------------|----------|
| Nickname    |        jo            |    no    |
| First Name  |        John          |    yes   |
| Last Name   |        Doe           |    yes   |


Precise position validation sample:

	class MyParser

		attr_accessor :file_path

		def initialize file_path
			@file_path = file_path
		end

		def data
			@data_wrapper ||= Csv2hash.new(definition, file_path).parse
		end

		private

		def rules
			[].tap do |mapping|
				mapping << { position: [2,1], key: 'first_name' }
				mapping << { position: [3,1], key: 'last_name' }
			end
		end

		def definition
			Csv2Hash::Definition.new(rules, type = Csv2Hash::Definition::MAPPING, header_size: 1)
		end

	end

### Validation of a collection

Consider the following CSV:

| Nickname | First Name | Last Name |
|----------|------------|-----------|
|   jo     |    John    |    Doe    |
|   ja     |    Jane    |    Doe    |

Collection validation sample:

	class MyParser

		attr_accessor :file_path

		def initialize file_path
			@file_path = file_path
		end

		def data
			@data_wrapper ||= Csv2hash.new(definition, file_path).parse
		end

		private

		def rules
			[].tap do |mapping|
				mapping << { position: 0, key: 'nickname'   }
				mapping << { position: 1, key: 'first_name' }
				mapping << { position: 2, key: 'last_name'  }
			end
		end

		def definition
			Csv2Hash::Definition.new(rules, type = Csv2Hash::Definition::COLLECTION, header_size: 1)
		end

	end


### Structure validation rules

You may want to validate some structure, like min or max number of columns, definition accepts structure_rules as a key for the third parameter.
Current validations are: MinColumn, MaxColumn

class MyParser

	attr_accessor :file_path

	def initialize file_path
		@file_path = file_path
	end

	def data
		@data_wrapper ||= Csv2hash.new(definition, file_path).parse
	end

	private

	def rules
		[].tap do |mapping|
			mapping << { position: 0, key: 'nickname'   }
			mapping << { position: 1, key: 'first_name' }
			mapping << { position: 2, key: 'last_name'  }
		end
	end

  def definition
	  Csv2Hash::Definition.new(rules, type = Csv2Hash::Definition::COLLECTION, structure_rules: {'MinColumn' => 2, 'MaxColumn' => 3})
  end
end


### CSV Headers

You can define the number of rows to skip in the header of the CSV.

	Definition.new(rules, type, header_size=0)

### Parser and configuration

Pasrer take severale parameters like that :

	initialize definition, file_path, exception_mode=true, data_source=nil, ignore_blank_line=false

you can pass directly Array of data (Array at 2 dimensions) really useful for testing, if you don't care about line blank in your CSV you can ignore them.

### Response

The parser return values wrapper into DataWrapper Object, you can call .valid? method on this Object and grab either data or errors like that :

    response = parser.parse
    if response.valid?
	    response.data
    else
	    response.errors
    end

data or errors are Array, but errors can be formatted on csv format with .to_csv call

	response.errors.to_csv

## Exception or Not !

You can choice 2 modes of parsing, either **exception mode** for raise exception in first breaking rules or **csv mode** for get csv original data + errors throwing into added columns.

### On **CSV MODE** you can choose different way for manage errors

`.parse()` return `data_wrapper` if `.parse()` is invalid, you can code your own behavior like that :

in your code

	parser = Csv2hash.new(definition, 'file_path').new
	response = parser.parse
	return response if response.valid?
	# Whatever

In the same time Csv2hash call **notify(response)** method when CSV parsing fail, you can add your own Notifier like that

	module Csv2hash
		module Plugins
			class Notifier
				def initialize csv2hash
					csv2hash.notifier.extend NotifierWithEmail
				end

				module NotifierWithEmail
					def notify response
						filename = 'issues_errors.csv'
						tempfile = Tempfile.new [filename, File.extname(filename)]
						File.open(tempfile.path, 'wb') { |file| file.write response.errors.to_csv }
						# Send mail with csv file + errors and free resource
						tempfile.unlink
					end
				end
			end
		end
	end

Or other implementation

### Errors Format

errors is a Array of Hash

	{ y: 1, x: 0, message: 'message', key: 'key', value: '' }

## Sample

### Csv data

| Fields      | Person Informations  |
|-------------|----------------------|
| Nickname    |        nil           |

### Rule

	{ position: [1,1], key: 'nickname', allow_blank: false }

### Error

	{ y: 1, x: 1, message: 'undefined nikcname on [0, 0]', key: 'nickname', value: nil }
## Personal Validator Rule

You can define your own Validator

For downcase validation

	class DowncaseValidator < Csv2hash::ExtraValidator
		def valid? value
			!!(value.match /^[a-z]+$/)
		end
	end

in your rule

	{ position: [0,0], key: 'name', extra_validator: DowncaseValidator.new,
		message: 'your data should be writting in downcase only' }

Csv data

	[ [ 'Foo' ] ]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request