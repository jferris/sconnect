module Sconnect
  class NotScope < ActiveRecord::NamedScope::Scope

    delegate :current_scoped_methods, :sanitize_sql, :to => :proxy_scope

    def initialize(proxy_scope)
      @proxy_scope = proxy_scope
    end

    def proxy_options
      @proxy_options ||= invert_scope_conditions(@right_scope)
    end

    private

    def invert_scope_conditions(scope)
      scope = scope.merge(:conditions => invert_conditions(scope[:conditions]))
    end

    def invert_conditions(conditions)
      "NOT (#{sanitize_sql(conditions)})"
    end

    def method_missing(method, *args, &block)
      if scopes.include?(method)
        right_scope = scopes[method].call(self, *args)
        if @right_scope
          right_scope
        else
          @right_scope = right_scope.proxy_options
          self
        end
      else
        super(method, *args, &block)
      end
    end
  end

  module ActiveRecordClassExtensions
    def not
      NotScope.new(self)
    end
  end
end
