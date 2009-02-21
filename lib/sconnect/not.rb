module Sconnect #:nodoc:
  class NotScope < ActiveRecord::NamedScope::Scope #:nodoc:

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
    # Inverts the conditions of the following scope.
    #
    # Examples:
    #   # Returns all unpublished posts
    #   Post.not.published 
    #
    #   # Returns all unpublished posts from today
    #   Post.not.published.from_today
    #
    #   # Same as above
    #   Post.from_today.not.published
    def not
      NotScope.new(self)
    end
  end
end
