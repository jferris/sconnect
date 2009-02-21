require 'sconnect/or'

module ActiveRecord
  module NamedScope
    class Scope
      include Sconnect::ScopeExtensions
    end
  end
end
