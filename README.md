Ruby CoffeeScript Multi
=======================

Ruby CoffeeScript is a bridge to the official CoffeeScript compiler.

```ruby
available_versions = CoffeeScript.all_available_versions
default_version    = CoffeeScript.default_version

CoffeeScript.compile_with_version default_version, File.read("script.coffee")
```


Installation
------------

```
gem install coffee-script-multi
```

Dependencies
------------

### JSON

The `json` library is also required but is not explicitly stated as a
gem dependency. If you're on Ruby 1.8 you'll need to install the
`json` or `json_pure` gem. On Ruby 1.9, `json` is included in the
standard library.

### ExecJS

The [ExecJS](https://github.com/sstephenson/execjs) library is used to automatically choose the best JavaScript engine for your platform. Check out its [README](https://github.com/sstephenson/execjs/blob/master/README.md) for a complete list of supported engines.
