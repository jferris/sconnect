module Matchers

  class ScopeOptionsMatcher
    def initialize(scope)
      @expected_scope_options = scope.proxy_options.dup
      @expected_scope_options.delete(:conditions)
    end

    def matches?(target)
      target_scope_options = target.proxy_options
      @expected_scope_options.detect do |@key, expected_values|
        expected_values = [expected_values] unless expected_values.is_a?(Array)
        @target_values = target_scope_options[@key]
        @target_values = [@target_values] unless @target_values.is_a?(Array)
        @missing = 
          expected_values.detect {|value| !@target_values.include?(value) }
      end

      @missing.nil?
    end

    def failure_message
      "Missing value #{@missing.inspect} for #{@key.inspect}" <<
        " (found values: #{@target_values.inspect})"
    end
  end

  def include_scope_options_from(scope)
    ScopeOptionsMatcher.new(scope)
  end
end
