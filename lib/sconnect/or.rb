module Sconnect
  class OrScope < ActiveRecord::NamedScope::Scope

    attr_reader :proxy_scope, :left_scope, :right_scope
    delegate :scopes, :with_scope, :to => :model

    def initialize(left_scope)
      @left_scope  = left_scope.proxy_options
      @proxy_scope = left_scope.proxy_scope
    end

    def proxy_options
      @proxy_options ||= inclusively_combine_scopes(left_scope, right_scope)
    end

    private

    def inclusively_combine_scopes(*scopes)
      # puts "Combining scopes: #{scopes.inspect}"

      segments = scopes.collect do |scope|
        model.send(:sanitize_sql, scope[:conditions])
      end
      conditions = "(#{segments.join(') OR (')})"

      scopes.first.merge(:conditions => conditions)
    end

    def model
      @model ||= proxy_scope
      until @model.superclass == ActiveRecord::Base
        @model = @model.proxy_scope
      end
      @model
    end

    def method_missing(method, *args, &block)
      # puts "#{method} called from #{caller.first}"
      if scopes.include?(method)
        right_scope = scopes[method].call(self, *args)
        if @right_scope
          # puts "Combining with scope: #{method}"
          right_scope
        else
          @right_scope = right_scope.proxy_options
          # puts "Setting right scope: #{@right_scope.inspect}"
          self
        end
      else
        # puts "Calling #{method} on proxy with scope: #{proxy_options.inspect}"
        with_scope :find => proxy_options, :create => proxy_options[:conditions].is_a?(Hash) ?  proxy_options[:conditions] : {} do
          proxy_scope.send(method, *args, &block)
        end
      end
    end
  end

  module ScopeExtensions
    def or
      OrScope.new(self)
    end
  end
end
