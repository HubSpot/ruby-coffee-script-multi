Gem::Specification.new do |s|
  s.name    = 'coffee-script-multi'
  s.version = '0.0.1'

  s.homepage    = "http://github.com/HubSpot/ruby-coffee-script-multi"
  s.summary     = "Ruby CoffeeScript Compiler that supports multiple versions"
  s.description = <<-EOS
    Ruby CoffeeScript is a bridge to the JS CoffeeScript compiler.
  EOS
  s.license = "MIT"

  s.files = [
    'lib/coffee-script.rb',
    'lib/coffee_script.rb',

    'vendor/coffee-script-1.4.0.js',
    'vendor/coffee-script-1.6.2.js',
    'vendor/coffee-script-1.7.1.js',
    'vendor/coffee-script-1.9.1.js',

    'LICENSE',
    'README.md'
  ]

  s.add_dependency 'execjs'
  s.add_development_dependency 'json'
  s.add_development_dependency 'rake'

  s.authors = ['Jeremy Ashkenas', 'Joshua Peek', 'Sam Stephenson', 'Tim Finley']
  s.email   = 'tfinley@hubspot.com'
end
