### VERSION 0.5.0

* backwards incompatible changes
  * The signature of Csv2hash::Main#new has changed.

* refactoring
  * remove params ``` ignore_blank_line ``` to benefit of options of Hash 

### VERSION 0.4.0

* backwards incompatible changes
  * The signature of Csv2hash::Main#new has changed.

* refactoring
  * remove params ``` break_on_failure ``` to benefit of ``` Csv2hash::Main#parse! ``` of ``` Csv2hash::Main#parse ```

### VERSION 0.3.0

* backwards incompatible changes
  * Csv2hash is module now, call Csv2hash::Main.new
  * The signature of Csv2hash::Main#new has changed.

* refactoring
  * Use adapter to select source of data, either file.csv or Array of data, is more transparently, not impact signature of Csv2Hash constructor

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
