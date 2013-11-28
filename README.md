# Csv2Hash

[![Code Climate](https://codeclimate.com/github/joel/csv2hash.png)](https://codeclimate.com/github/joel/csv2hash)

[![Dependency Status](https://gemnasium.com/joel/csv2hash.png)](https://gemnasium.com/joel/csv2hash)

[![Build Status](https://travis-ci.org/joel/csv2hash.png?branch=master)](https://travis-ci.org/joel/csv2hash) (Travis CI)

[![Coverage Status](https://coveralls.io/repos/joel/csv2hash/badge.png)](https://coveralls.io/r/joel/csv2hash)


It's DSL for valided ant mapped CSV to Ruby Hash

## Installation

Add this line to your application's Gemfile:

    gem 'csv2hash'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install csv2hash

## Usage

You should be declare on definition for you CSV, for each cells you should define what you expect.

Example :

You want first cell parsed should be string with values are yes or no you must fill follow rule :

	{ name: 'aswering', type: 'string', values: ['yes', 'no'], position: [0,0] }

Some key as default value, so you can just define this rule :

	{ name: 'aswering', values: ['yes', 'no'], position: [0,0] }

You can define message, if you insert key on you message their sub

	{ name: 'aswering', values: ['yes', 'no'], position: [0,0], message: 'this value is not supported' }

if you insert key on you message their substitue by value

	{ ..., message: 'value of :name is not supported, please you one of :values' }

produce 'value of aswering is not supported, please you one of [yes, no]'

#### Default values

* message:     'undefined :key on :position'
* mappable:    true
* type:        'string'
* values:      nil
* nested:      nil
* allow_blank: false
* position:    nil
* maptype:     'cell'

### Limitations


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
