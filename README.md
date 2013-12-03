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

#### Rules

You should declare a definition for you CSV, and then define for each cell what you would expect.

Example :

You want the cell located on first line, first column to be a string with its values to be 'yes' or 'no'. Then you can right the following validation rule :

	{ name: 'aswering', type: 'string', values: ['yes', 'no'], position: [0,0] }

The type is 'string' by default, so can just write:

	{ name: 'aswering', values: ['yes', 'no'], position: [0,0] }

You can define a message, default is 'undefined :key on :position'

	{ name: 'aswering', values: ['yes', 'no'], position: [0,0], message: 'this value is not supported' }

the message is parsed:
You can also define Range

	{ name: 'score', values: 0..5, position: [0,0] }


	{ ..., message: 'value of :name is not supported, please you one of :values' }

It produces :

	value of aswering is not supported, please you one of [yes, no]

#### Define where your data is expected
Position mean [Y, X], where Y is rows, X columns

A definition should be provided. There are 2 types of definitions:
* search for data at a precise position in the table: `x,y`
* or search for data in a column of row, where all the rows are the same: `x` (column number)

### Samples

#### Validation of a cell at a precise position

Consider the following CSV:

| Fields      | Person Informations  | Optional |
|-------------|----------------------|----------|
| Nickname    |        Jo            |    no    |
| First Name  |        John          |    yes   |
| Last Name   |        Doe           |    yes   |


Precise position validation sample:

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
			Csv2Hash::Definition.new(rules, type = Csv2Hash::Definition::MAPPING)
		end

		def data
			Csv2hash.new(definition, file_path).tap do |csv2hash|
				csv2hash.parse
			end.data
		end

	end

#### Validation of a collection

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

		def rules
			[].tap do |mapping|
				mapping << { position: 0, key: 'nickname'   }
				mapping << { position: 1, key: 'first_name' }
				mapping << { position: 2, key: 'last_name'  }
			end
		end

		def definition
			Csv2Hash::Definition.new(rules, type = Csv2Hash::Definition::COLLECTION)
		end

		def data
			Csv2hash.new(definition, file_path).tap do |csv2hash|
				csv2hash.parse
			end.data
		end

	end

#### Headers

You can define the number of rows to skip in the header of the CSV.

	Definition.new(rules, type, header_size=0)

#### Exception or CSV mode

You can choice 2 mode of parsing, either exception mode for raise exception in first breaking rules or csv mode for get csv original data + errors throwing into added columns.


parse return data or csv_with_errors if parse is invalid, you can plug this like that :

	csv2hash = Csv2hash.new(definition, 'file_path').new
	result = csv2hash.parse
	return result if csv2hash.valid?

	filename = 'issues_errors.csv'
	tempfile = Tempfile.new [filename, File.extname(filename)]
	File.open(tempfile.path, 'wb') { |file| file.write result }

	# Send mail with csv file + errors and free resource

	tempfile.unlink


#### Default values

Only position is required:

* :position

All remaining keys are optionals:

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