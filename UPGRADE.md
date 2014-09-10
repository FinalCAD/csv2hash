# Upgrading

# Upgrading from 0.6.5 to 0.6.6

nothing

# Upgrading from 0.6.4 to 0.6.5

nothing

# Upgrading from 0.6.3 to 0.6.4

nothing

# Upgrading from 0.6.2 to 0.6.3

nothing

# Upgrading from 0.6.1 to 0.6.2

nothing

# Upgrading from 0.6 to 0.6.1

Change Structure validation rules, MinColumn, MaxColumn are replaced by :min_columns, :max_columns

# Upgrading from 0.5 to 0.6

Introduce DSL

Prior to 0.6 :

```
  rules = [{ position: [0,0], key: 'name' }]
  Csv2hash::Definition.new(rules, Definition::MAPPING, options={})

```

Starting from 0.6 :

```
  Csv2hash::Main.generate_definition :foo do
    set_type { Definition::MAPPING }
    mapping { cell position: [0,0], key: 'name' }
  end
  Csv2hash::Main[:foo] # Access anywhere
```

# Upgrading from 0.4 to 0.5

Signature of ```Csv2hash::Main#new``` has changed too

Prior to 0.5 :

```
  Csv2Hash::Main.new(definition, file_path_or_data, ignore_blank_line=false)
```

Starting from 0.5 :

```
  Csv2Hash::Main.new(definition, file_path_or_data, ignore_blank_line: false)
```

# Upgrading from 0.3 to 0.4

Signature of ```Csv2hash::Main#new``` has changed too

Prior to 0.4 :

```
  Csv2Hash::Main.new(definition, file_path_or_data, break_on_failure=true, ignore_blank_line=false)
```

call ```.parse!``` for same result

Starting from 0.4 :

```
  Csv2Hash::Main.new(definition, file_path_or_data, ignore_blank_line=false)
```

call ```.parse``` for same result

# Upgrading from 0.2 to 0.3

```Csv2hash``` become an ```Module```,  ```Csv2hash.new``` no longer works, please use ```Csv2hash::Main.new``` instead.
Signature of ```Csv2hash::Main#new``` has changed too

Prior to 0.3 :

```
  Csv2Hash.new(definition, file_path, break_on_failure=true, data_source=nil, ignore_blank_line=false)
```

Starting from 0.3 :

```
  Csv2Hash::Main.new(definition, file_path_or_data, break_on_failure=true, ignore_blank_line=false)
```

# Upgrading from 0.1 to 0.2

The signature of Definition#new has changed, the last parameter is a configuration hash, while in versions prior to 0.2 it was an integer (header_size) consider upgrading your code :

Prior to 0.2 :

```
  Csv2Hash::Definition.new(rules, type = Csv2Hash::Definition::COLLECTION, 1)
```

Starting from 0.2 :

```
  Csv2Hash::Definition.new(rules, type = Csv2Hash::Definition::COLLECTION, header_size: 1)
```

If no configuration is passed, header_size defaults remains to 0
