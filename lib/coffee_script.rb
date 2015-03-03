require 'execjs'

module CoffeeScript
  Error            = ExecJS::Error
  EngineError      = ExecJS::RuntimeError
  CompilationError = ExecJS::ProgramError

  module MultiSource

    def default_version
      ENV['COFFEESCRIPT_DEFAULT_VERSION'] || '1.4.0'
    end

    def self.path_for(version)
      @path ||= {}
      @path[version] ||= File.join sources_directory, "coffee-script-#{version}.js"
    end

    def self.contents_for(version)
      @contents ||= {}
      @contents[version] ||= File.read(path_for(version))
    end

    def self.bare_option(version)
      @base_option ||= {}
      @bare_option[version] ||= contents_for(version).match(/noWrap/) ? 'noWrap' : 'bare'
    end

    def self.context_for(version)
      @context ||= {}
      @context[version] ||= ExecJS.compile(contents_for(version))
    end

    def self.sources_directory
      File.expand_path("../../vendor", __FILE__)
    end

  end

  class << self

    def default_version
      version = ENV['COFFEESCRIPT_DEFAULT_VERSION'] || '1.4.0'

      unless all_available_versions.include? version
        raise "default CoffeeScript version isn't availale"
      end

      version
    end

    # Look for coffee-script-*.js in the vendor/js folder
    def all_available_versions
      js_paths = Dir.glob File.join MultiSource.sources_directory, "coffee-script*"

      js_paths.map do |path|
        filename = File.basename path
        filename.sub(/^coffee-script-?/, '').sub(/\.js$/, '')
      end.compact
    end

    # Compile a script (String or IO) to JavaScript.
    def compile_with_version(version, script, options = {})
      script  = script.read if script.respond_to?(:read)

      if options.key?(:bare)
      elsif options.key?(:no_wrap)
        options[:bare] = options[:no_wrap]
      else
        options[:bare] = false
      end

      wrapper = <<-WRAPPER
        (function(script, options) {
          try {
            return CoffeeScript.compile(script, options);
          } catch (err) {
            if (err instanceof SyntaxError && err.location) {
              throw new SyntaxError([
                err.filename || "[stdin]",
                err.location.first_line + 1,
                err.location.first_column + 1
              ].join(":") + ": " + err.message)
            } else {
              throw err;
            }
          }
        })
      WRAPPER

      MultiSource.context_for(version).call(wrapper, script, options)
    end
  end
end
