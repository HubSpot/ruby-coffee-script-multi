begin
  require 'minitest/autorun'
rescue LoadError
  require 'test/unit'
end

TestCase = if defined? Minitest::Test
    Minitest::Test
  elsif defined? MiniTest::Unit::TestCase
    MiniTest::Unit::TestCase
  else
    Test::Unit::TestCase
  end

require 'coffee_script'
require 'stringio'


class TestCoffeeScript < TestCase
  def test_compile
    assert_match "puts('Hello, World!')",
      CoffeeScript.compile_with_version("1.4.0", "puts 'Hello, World!'\n")
  end

  def has_same_elements?(array_one, array_two)
    ((array_one - array_two) + (array_two - array_one)).empty?
  end

  def test_available_versions
    assert has_same_elements? ['1.4.0', '1.6.2', '1.7.1'], CoffeeScript::all_available_versions
  end

  def test_all_versions
    CoffeeScript::all_available_versions.each do |version|
      assert_match "puts('Hello, World!')",
        CoffeeScript.compile_with_version(version, "puts 'Hello, World!'\n")
    end
  end

  def test_one_point_seven_point_one_chaining_changes
    src = <<-EOS
$ '#element'
.addClass 'active'
.css { left: 5 }
    EOS

    expected = <<-EOS
(function() {
  $('#element').addClass('active').css({
    left: 5
  });

}).call(this);
    EOS

    assert_match expected, CoffeeScript.compile_with_version("1.7.1", src)
  end

  def test_compile_with_io
    io = StringIO.new("puts 'Hello, World!'\n")
    assert_match "puts('Hello, World!')",
      CoffeeScript.compile_with_version("1.4.0", io)
  end

  def test_compile_with_bare_true
    assert_no_match "function()",
      CoffeeScript.compile_with_version("1.4.0", "puts 'Hello, World!'\n", :bare => true)
  end

  def test_compile_with_bare_false
    assert_match "function()",
      CoffeeScript.compile_with_version("1.4.0", "puts 'Hello, World!'\n", :bare => false)
  end

  def test_compile_with_no_wrap_true
    assert_no_match "function()",
      CoffeeScript.compile_with_version("1.4.0", "puts 'Hello, World!'\n", :no_wrap => true)
  end

  def test_compile_with_no_wrap
    assert_match "function()",
      CoffeeScript.compile_with_version("1.4.0", "puts 'Hello, World!'\n", :no_wrap => false)
  end

  def test_compilation_error
    error_messages = [
      # <=1.4
      "Error: Parse error on line 4: Unexpected 'POST_IF'",
      # 1.5
      "Error: Parse error on line 3: Unexpected 'POST_IF'",
      # 1.6
      "SyntaxError: [stdin]:3:13: unexpected POST_IF",
      # 1.7
      "SyntaxError: [stdin]:3:13: unexpected unless"

    ]
    CoffeeScript::all_available_versions.each do |version|
      begin
        src = <<-EOS
          sayHello = ->
            console.log "hello, world"
            unless
        EOS

        CoffeeScript.compile_with_version(version, src)
        flunk
      rescue CoffeeScript::Error => e
        # print "\n", "e:  #{e.inspect} (version #{version})", "\n\n"
        assert error_messages.include?(e.message),
          "message was #{e.message.inspect}"
      end
    end
  end

  def assert_no_match(expected, actual)
    assert !expected.match(actual)
  end
end
