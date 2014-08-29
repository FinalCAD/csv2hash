# Csv2Hash

[![Code Climate](https://codeclimate.com/github/FinalCAD/csv2hash.png)](https://codeclimate.com/github/FinalCAD/csv2hash)

[![Dependency Status](https://gemnasium.com/FinalCAD/csv2hash.png)](https://gemnasium.com/FinalCAD/csv2hash)

[![Build Status](https://travis-ci.org/FinalCAD/csv2hash.png?branch=master)](https://travis-ci.org/FinalCAD/csv2hash) (Travis CI)

[![Coverage Status](https://coveralls.io/repos/FinalCAD/csv2hash/badge.png)](https://coveralls.io/r/FinalCAD/csv2hash)

It is a DSL to validate and map a CSV to a Ruby Hash.

## Installation

Add this line to your application's Gemfile:

    gem 'csv2hash'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install csv2hash

## Usage

Parsing is based on rules, you should defined rule for each cells

### DSL

```
  Csv2hash::Main.generate_definition :name do
    set_type { Definition::MAPPING }
    set_header_size { 2 } # 0 by default
    set_structure_rules {{ 'MaxColumns' => 2 }}
    mapping do
      cell position: [0,0], key: 'gender'
      cell position: [1,0], key: 'name'
    end
  end
  Csv2hash::Main[:name] # Access anywhere
```

### Rules

You should declared a definition of your CSV file, and then define for each cell what you would expect.

Example :

If you want the very first cell, located on the first line and on the first column to be a string with values are either 'yes' either 'no', you can write the following validation rule:

```
	cell name: 'aswering', type: 'string', values: ['yes', 'no'], position: [0,0]
```

`:type` attribute has `String` for default value, therefore you can just write this:

```
	cell name: 'aswering', values: ['yes', 'no'], position: [0,0]
```

You can define you own message but default message is 'undefined :key on :position'

```
	cell name: 'aswering', values: ['yes', 'no'], position: [0,0], message: 'this value is not supported'
```

You can also define Range of values

```
	cell name: 'score', values: 0..5, position: [0,0]
```

The message is parsed:

```
	cell ..., message: 'value of :name is not supported, please you one of :values'
```

It produces :

```
	value of answering is not supported, please use one of [yes, no]
```

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

**IMPORTANT!** Position means [Y, X], where Y is rows, X columns

A definition should be provided. There are 2 types of definitions:
* search for data at a precise position in the table: `y,x`
* or search for data in a column of rows, where all the rows are the same: `x` (column index)

## Samples

### [MAPPING] Validation of cells with defined precision

Consider the following CSV:

| Fields      | Person Informations  | Optional |
|-------------|----------------------|----------|
| Nickname    |        jo            |    no    |
| First Name  |        John          |    yes   |
| Last Name   |        Doe           |    yes   |


Precise position validation sample:

```
	class MyParser

		attr_accessor :file_path_or_data

		def initialize file_path_or_data
			@file_path_or_data = file_path_or_data
		end

		def data
			@data_wrapper ||= Csv2hash::Main.new(Csv2hash::Main[:<definition_name>], file_path_or_data).parse
		end

		private

		def definition
	      Main.generate_definition :my_defintion do
	        set_type { Definition::MAPPING }
	        set_header_size { 1 }
	          mapping do
	            cell position: [2,1], key: 'first_name'
	            cell position: [3,1], key: 'last_name'
	          end
	        end
	      end
		end

	end
```

### [COLLECTION] Validation of a collection (Regular CSV)

Consider the following CSV:

| Nickname | First Name | Last Name |
|----------|------------|-----------|
|   jo     |    John    |    Doe    |
|   ja     |    Jane    |    Doe    |

Collection validation sample:

```
	class MyParser

		attr_accessor :file_path_or_data

		def initialize file_path_or_data
			@file_path_or_data = file_path_or_data
		end

		def data
			@data_wrapper ||= Csv2hash::Main.new(Csv2hash::Main[:<definition_name>], file_path_or_data).parse
		end

		private

		def definition
			Csv2Hash::Definition.new(rules, type = Csv2Hash::Definition::COLLECTION, header_size: 1)
		end

	    def definition
	      Main.generate_definition :my_defintion do
	        set_type { Definition::COLLECTION }
	        set_header_size { 1 }
	          mapping do
	            cell position: 0, key: 'nickname'
	            cell position: 1, key: 'first_name'
	            cell position: 2, key: 'last_name'
	          end
	        end
	      end
	    end

	end
```

### Structure validation rules

You may want to validate some structure, like min or max number of columns, definition accepts structure_rules as a key for the third parameter.
Current validations are: MinColumn, MaxColumn

```
  class MyParser

  	attr_accessor :file_path_or_data

  	def initialize file_path_or_data
  		@file_path_or_data = file_path_or_data
  	end

  	def data
  		@data_wrapper ||= Csv2hash::Main.new(Csv2hash::Main[:<definition_name>], file_path_or_data).parse
  	end

  	private

    def definition
      Main.generate_definition :my_defintion do
        set_type { Definition::COLLECTION }
        set_header_size { 1 }
        set_structure_rules {{ 'MinColumns' => 2, 'MaxColumns' => 3 }}
          mapping do
            cell position: 0, key: 'nickname'
            cell position: 1, key: 'first_name'
            cell position: 2, key: 'last_name'
          end
        end
      end
    end
  end
```

### CSV Headers

You can define the number of rows to skip in the header of the CSV.

```
	set_header_size { 1 }
```

### Parser and configuration

Pasrer can take several parameters like that:

```
	definition, file_path_or_data, ignore_blank_line: false
```

in `file_path_or_data` attribute you can pass directly an `Array` of data (`Array` with 2 dimensions) really useful for testing, if you don't care about blank lines in your CSV you can ignore them.

### Response

The parser return values wrapper into `DataWrapper Object`, you can call ```.valid?``` method on this Object and grab either data or errors like that :

```
    response = parser.parse
    if response.valid?
	    response.data
    else
		response.errors
    end
```

data or errors are Array, but errors can be formatted on csv format with .to_csv call

```
	response.errors.to_csv
```

## Exception or Not !

You can choose into 2 differents modes of parsing, either **break_on_failure mode** for throw an exception when rule fail or **csv mode** for get csv original data + errors throwing into added extra column.

### On **BREAK_ON_FAILURE MODE**

You need call ```.parse()``` with bang ```!```

### On **CSV MODE**

You need call `.parse()` return `data_wrapper` if `.parse()` is invalid, you can code your own behavior:

in your code

```
	parser = Csv2hash::Main.new(definition, file_path_or_data, ignore_blank_line: false).new
	response = parser.parse
	return response if response.valid?
	# Whatever
```

In the same time Csv2hash call **notify(response)** method when CSV parsing fail, you can add your own Notifier:

```
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
```

Or other implementation

### Errors Format

errors is a Array of Hash

```
	{ y: 1, x: 0, message: 'message', key: 'key', value: '' }
```

## Sample

### Csv data

| Fields      | Person Informations  |
|-------------|----------------------|
| Nickname    |        nil           |

### Rule

```
	cell position: [1,1], key: 'nickname', allow_blank: false
```

### Error

```
	{ y: 1, x: 1, message: 'undefined nikcname on [0, 0]', key: 'nickname', value: nil }
```

## Personal Validator Rule

You can define your own Validator

For downcase validation

```
	class DowncaseValidator < Csv2hash::ExtraValidator
		def valid? value
			!!(value.match /^[a-z]+$/)
		end
	end
```

in your rule

```
	cell position: [0,0], key: 'name', extra_validator: DowncaseValidator.new,
		message: 'your data should be written in lowercase only.'
```

Csv data

```
	[ [ 'Foo' ] ]
```

# Upgrading

please refere to [UPGRADE.md](https://github.com/FinalCAD/csv2hash/blob/master/UPGRADE.md) doc

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
