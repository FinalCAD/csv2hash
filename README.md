# Csv2Hash

[![Gem Version](https://badge.fury.io/rb/csv2hash.svg)](http://badge.fury.io/rb/csv2hash)

[![Code Climate](https://codeclimate.com/github/FinalCAD/csv2hash.png)](https://codeclimate.com/github/FinalCAD/csv2hash)

[![Dependency Status](https://gemnasium.com/FinalCAD/csv2hash.png)](https://gemnasium.com/FinalCAD/csv2hash)

[![Build Status](https://travis-ci.org/FinalCAD/csv2hash.png?branch=master)](https://travis-ci.org/FinalCAD/csv2hash) (Travis CI)

[![Coverage Status](https://coveralls.io/repos/FinalCAD/csv2hash/badge.png)](https://coveralls.io/r/FinalCAD/csv2hash)

It is a DSL to validate and map a CSV to a Ruby Hash.

# Summary

* [Csv2Hash](#csv2hash)
* [Summary](#summary)
  * [Installation](#installation)
  * [Usage](#usage)
    * [Invoke parser](#invoke-parser)
    * [Parser options](#parser-options)
  	* [Definition DSL](#definition-dsl)
    * [Definition Rules](#definition-rules)
    * [Default rules values](#default-rules-values)
    * [Define where your data are expected](#define-where-your-data-are-expected)
  * [Samples](#samples)
    * [Autodiscover generale setting](#autodiscover-generale-setting)
    * [[MAPPING] Validation of cells with defined precision](#mapping-validation-of-cells-with-defined-precision)
    * [Auto discover position feature in Mapping](#auto-discover-position-feature-in-mapping)
    * [[COLLECTION] Validation of a collection (Regular CSV)](#collection-validation-of-a-collection-regular-csv)
    * [Auto discover position feature in Collection](#auto-discover-position-feature-in-collection)
    * [Structure validation rules](#structure-validation-rules)
    * [CSV Headers](#csv-headers)
    * [Parser and configuration](#parser-and-configuration)
    * [Response](#response)
  * [Configuration](#configuration)
  * [Exception or Not !](#exception-or-not-)
    * [On **BREAK_ON_FAILURE MODE**](#on-break_on_failure-mode)
    * [On **CSV MODE**](#on-csv-mode)
    * [Errors Format](#errors-format)
      * [Sample](#sample)
        * [Csv data](#csv-data)
        * [Rule](#rule)
        * [Error](#error)
  * [Personal Validator Rule](#personal-validator-rule)
* [Yaml Config file](#yaml-config-file)
  * [YamlLoader](#yamlloader)
* [Type conversion](#type-conversion)
* [Changes](#changes)
* [Upgrading](#upgrading)
* [Yard doc](#yard-doc)
* [Contributing](#contributing)

## Installation

Add this line to your application's Gemfile:

    gem 'csv2hash'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install csv2hash

## Usage

Parsing is based on rules, you should defined rule for each cells

### Invoke parser

```
Csv2hash::Main.new(:<definition_name>, file_path_or_data, options).parse
```

```
Csv2hash::Main.new(:<definition_name>, options) do
  file_path_or_data
end.parse
```

### Parser options

List of options :

* `ignore_blank_line: :boolean` # i think is pretty straightforward to understand
* `sanitizer: :boolean` remove trailing space, example:

```
  '  it is   a really  good idea!!   '
```
become
```
  => "it is a really good idea!!"
```

### Definition DSL

```
Csv2hash::Main.generate_definition :name do
  set_type { Definition::MAPPING }
  set_header_size { 2 } # 0 by default
  set_structure_rules {{ max_columns: 2 }}
  mapping do
    cell position: [0,0], key: 'gender'
    cell position: [1,0], key: 'name'
  end
end
Csv2hash::Main[:name] # Access anywhere
```

### Definition Rules

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

By default values are case sensitive but if you want the value to be a string that can be either 'yes' or 'no' case insentive ('Yes', 'YES', 'No', 'NO') you can define the following validation rule:

```
cell name: 'aswering', values: ['yes', 'no'], case_sensitive_values: false, position: [0,0]
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

### Default rules values

Only position is required:

* :position

All remaining keys are optionals:

* message:     'undefined :key on :position'
* mappable:    true
* type:        'string'
* values:      nil
* case_sensitive_values: true # When you define set of 'values'
* nested:      nil
* allow_blank: false
* extra_validator: nil

### Define where your data are expected

**IMPORTANT!** Position means [Y, X], where Y is rows, X columns

A definition should be provided. There are 2 types of definitions:
* search for data at a precise position in the table: `y,x`
* or search for data in a column of rows, where all the rows are the same: `x` (column index)

## Samples

### Autodiscover generale setting

You can define your matching expression as exact match and case sensitive or not.

```
conf.ignore_case    = true # /Sex/ become /Sex/i
conf.exact_matching = true # /Sex/ become /\A(Sex)\z/
```

Both option can be cumulated : /Sex/ can become /\A(Sex)\z/i

For further information please see section [Configuration](#configuration)

### [MAPPING] Validation of cells with defined precision

Consider the following CSV:

```
| Fields      | Person Informations  | Optional |
|-------------|----------------------|----------|
| Nickname    |        jo            |    no    |
| First Name  |        John          |    yes   |
| Last Name   |        Doe           |    yes   |
```

Precise position validation sample:

```
class MyParser

	attr_accessor :file_path_or_data

	def initialize file_path_or_data
		@file_path_or_data = file_path_or_data
	end

	def data
		@data_wrapper ||= Csv2hash::Main.new(:<definition_name>, file_path_or_data).parse
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
```

### Auto discover position feature in Mapping

This is a special feature for finding the Y index of row where you data start. For instance you have this following data :

```
|---------------|---------------|------|-----|
| Nickname      | jo            |      |     |
| First Name    | John          |      |     |
| Last Name     | Doe           |      |     |
|               |               |      |     |
| Employment    | CEO           |      |     |
| Post          | Doe           |      |     |
|               |               |      |     |
|               | Personal info | Age  | 26  |
|               | Sex           | Male |     |
|               |               |      |     |
```

You want extract `Employment` information and `Personal info` but we do not know if extra information will not come and break our index. This feature can be useful is this case.

You must change Y position (rows) by the column index and regex, the parser will search on this column the index row of this regex, here our rule :

```
cell position: [4,1], key: 'employment'
```

became

```
cell position: [[0, /Employment/],1], key: 'employment'
```

or

```
cell position: [[0, 'Employment'],1], key: 'employment'
```

### [COLLECTION] Validation of a collection (Regular CSV)

Consider the following CSV:

```
| Nickname | First Name | Last Name |
|----------|------------|-----------|
|   jo     |    John    |    Doe    |
|   ja     |    Jane    |    Doe    |
```

Collection validation sample:

```
class MyParser

	attr_accessor :file_path_or_data

	def initialize file_path_or_data
		@file_path_or_data = file_path_or_data
	end

	def data
		@data_wrapper ||= Csv2hash::Main.new(:<definition_name>, file_path_or_data).parse
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
```

### Auto discover position feature in Collection

This is a special feature for finding a specific column index on header. For example you have the following data:


```
| Name          | Age           |
|---------------|---------------|
| John Doe      | 23            |  
| Jane Doe      | 28            |
|               |               |
|               |               |  
```

You want to extract `Name` and `Age` for all rows but you want the order of the columns to be able to change.
You change the position to the regex of column index you are looking for. So this how the position

```
cell position: 0, key: 'name'
```

can be change to

```
cell position: /Name/ key: 'name'
```

or

```
cell position: 'Name' key: 'name'
```

### Structure validation rules

You may want to validate some structure, like min or max number of columns, definition accepts structure_rules as a key for the third parameter.
Current validations are: :min_columns, :max_columns

```
class MyParser

	attr_accessor :file_path_or_data

	def initialize file_path_or_data
		@file_path_or_data = file_path_or_data
	end

	def data
		@data_wrapper ||= Csv2hash::Main.new(:<definition_name>, file_path_or_data).parse
	end

	private

  def definition
    Main.generate_definition :my_defintion do
      set_type { Definition::COLLECTION }
      set_header_size { 1 }
      set_structure_rules {{ min_columns: 2, max_columns: 3 }}
      mapping do
        cell position: 0, key: 'nickname'
        cell position: 1, key: 'first_name'
        cell position: 2, key: 'last_name'
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

## Configuration

You can add a configuration file on your Rails project under this directory

add file `config/initializers/csv2hash.rb`

You can use the Rails generator for this

`rails generate csh2hash:install`

```
Csv2hash.configure do |conf|
  # Conversion of values
  # conf.convert        = false # default: false
  # conf.true_values    = ['yes','y','t'] # default: ['yes','y','t']
  # conf.false_values   = ['no','n','f']  # default: ['no','n','f']
  # conf.nil_values     = ['nil','null']  # default: ['nil','null']

  # Auto discover for (mapping and collection)
  # conf.ignore_case    = false # default: false
  # conf.exact_matching = false # default: false
end
```

For explanation of "Conversion of values" please take a look on [Type conversion](#type-conversion)

For explanation of "Auto discover for (mapping and collection)" please take a look on [Autodiscover generale setting](#autodiscover-generale-setting)

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

#### Sample

##### Csv data

```
| Fields      | Person Informations  |
|-------------|----------------------|
| Nickname    |        nil           |
```

##### Rule

```
cell position: [1,1], key: 'nickname', allow_blank: false
```

##### Error

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

# Yaml Config file

You can defined rules into a yaml file

```
name: 'example'
mapping: 'mapping'
header_size: 2
structure_rules: { max_columns: 20 }
rules:
  - { position: [1,1], key: 'first_name' }
  - { position: [2,1], key: 'first_name' }
```

or for complex and verbose rule

```
name: 'example'
mapping: 'mapping'
header_size: 2
structure_rules: { max_columns: 20 }
rules:
  - !rule
    position: [1,1]
    key: 'first_name'
  - !rule
    position: [2,1]
    key: 'last_name'
```

Special attention, if you use `ExtraValidator` you must give only the String name of the classe, like that :

```
extra_validator: DowncaseValidator.new
```

should become

```
extra_validator: 'DowncaseValidator'
```

for autodiscover field you must give String without Regex like that :

```
position: [[0,/LastName/],1]
```

should become

```
position: [[0,'LastName'],1]
```

this change is due to Yaml conversion

You can write ERB file, should be named with following convention ```<file name>.yml.erb```

## YamlLoader

You can load your definition with YamlLoader llike that :

```
loader = Csv2hash::YamlLoader.load!('config/rules.yml.erb')
loader.definition
```
or
```
loader = Csv2hash::YamlLoader.new('config/rules.yml.erb')
loader.load!
loader.definition
```

# Type conversion

By default Csv2hash doesn't convert basic value, but you can activate this option `convert = true`

You can define which String are converted on `true`, `false` or `nil`

```
true_values = ['yes','y','t']
```

With this configuration 'Yes' become => true (Basic boolean ruby value)

```
conf.false_values = ['no','n','f']
```

With this configuration 'No' become => false (Basic boolean ruby value)

```
conf.nil_values = ['nil','null']
```

With this configuration 'Null' become => nil (Basic ruby value)

For further information please see section [Configuration](#configuration)

# Changes

please refere to [CHANGELOG.md](https://github.com/FinalCAD/csv2hash/blob/master/CHANGELOG.md) doc

# Upgrading

please refere to [UPGRADE.md](https://github.com/FinalCAD/csv2hash/blob/master/UPGRADE.md) doc

# Yard doc

```
bundle exec yard --plugin tomdoc
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
