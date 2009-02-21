# This allows Scope objects to be used as matchers. Without this hack, a Scope
# will be converted to an array when #should is called, so the matcher will
# always receive an array. This prevents #should from being delegated to the
# Scope's proxy.
module ActiveRecord
  module NamedScope
    class Scope
      remove_method :should
    end
  end
end
