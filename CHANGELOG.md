### VERSION 0.6.6

* refactoring
  * little trick on YamlLoader

* [fullchanges](https://github.com/FinalCAD/csv2hash/commit/a4b3fb5b6cdb3ed41b039f68391b30054fab3668)

### VERSION 0.6.5

* enhancements
  * Add Coercer for deserialize field from Yaml like ExtraValidator and Regex
  * Add Coercer for deserialize field from Csv value to ruby value like 'true' => true
  * Add missing module prefix Csv2hash
  * remove rule for dynmaic field with field is optional and not found

* feature
  * Add generator for configure csv2hash on Rails app

* [fullchanges](https://github.com/FinalCAD/csv2hash/pull/16)

### VERSION 0.6.4

* feature
  * make configuration file can be writing with ERB interpolation.

* [fullchanges](https://github.com/FinalCAD/csv2hash/pull/15)

### VERSION 0.6.3

* refactoring
  * The Main constructor can be take in first arg a definition itself or simply the path of yaml file definition or just symbol of name of definition (when it have already loaded)

* feature
  * add yml loader

* [fullchanges](https://github.com/FinalCAD/csv2hash/pull/14)

### VERSION 0.6.2

* feature
  * Auto discover, you can add floating position on mapping rules

* [fullchanges](https://github.com/FinalCAD/csv2hash/pull/12)

### VERSION 0.6.1

* deprecations
  * Structure validation rules, MinColumn, MaxColumn are replaced by :min_columns, :max_columns

* [fullchanges](https://github.com/FinalCAD/csv2hash/pull/11)

### VERSION 0.6.0

* backwards incompatible changes
  * Introduce DSL for definition

* refactoring
  * replace arguments for rules by DSL of cells

* [fullchanges](https://github.com/FinalCAD/csv2hash/pull/10)

### VERSION 0.5.0

* backwards incompatible changes
  * The signature of Csv2hash::Main#new has changed.

* refactoring
  * remove params ``` ignore_blank_line ``` to benefit of options of Hash

* [fullchanges](https://github.com/FinalCAD/csv2hash/pull/9)

### VERSION 0.4.0

* backwards incompatible changes
  * The signature of Csv2hash::Main#new has changed.

* refactoring
  * remove params ``` break_on_failure ``` to benefit of ``` Csv2hash::Main#parse! ``` of ``` Csv2hash::Main#parse ```

* [fullchanges](https://github.com/FinalCAD/csv2hash/pull/8)

### VERSION 0.3.0

* backwards incompatible changes
  * Csv2hash is module now, call Csv2hash::Main.new
  * The signature of Csv2hash::Main#new has changed.

* refactoring
  * Use adapter to select source of data, either file.csv or Array of data, is more transparently, not impact signature of Csv2Hash constructor

* [fullchanges](https://github.com/FinalCAD/csv2hash/pull/7)

### VERSION 0.2.1

* bug fix
  * Correct little bug on error mode.

### VERSION 0.2

* backwards incompatible changes
  * The signature of Definition#new

* enhancements
  * Add checking of number of columns

* deprecations

### VERSION 0.1

* enhancements
  * Add csv errors mode
  * Add Extra Validator
  * Add Notifier Plugin
  * Add Data Wrapper Response
  * Add possibility to pass directly data in constructor, for more testing
  * You can ignore blank line

### VERSION 0.0.2

* enhancements
  * Liitle enhancement

### VERSION 0.0.1

* Skeleton and first parsing
