module Matchers

  class ScopeOptionsMatcher
    def initialize(expected)
      @expected_scope_options = scope_options(expected)
    end

    def matches?(target)
      target_scope_options = scope_options(target)
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

    private

    def scope_options(scope)
      scope_options = scope.scope_options
      scope_options.delete(:conditions)
      scope_options
    end
  end

  def include_scope_options_from(scope)
    ScopeOptionsMatcher.new(scope)
  end
end
