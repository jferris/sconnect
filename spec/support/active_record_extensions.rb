module ActiveRecord
  class Base
    # This allows us to look at the options at the end of a chain of scopes.
    def self.scope_options
      current_scoped_methods[:find]
    end
  end

  module NamedScope
    class Scope
      # This allows Scope objects to be used as matchers. Without this hack, a
      # Scope will be converted to an array when #should is called, so the
      # matcher will always receive an array. This prevents #should from being
      # delegated to the Scope's proxy.
      remove_method :should
    end
  end
end
