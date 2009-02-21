require 'sconnect/or'
require 'sconnect/not'

#:enddoc:
module ActiveRecord
  class Base
    extend Sconnect::ActiveRecordClassExtensions
  end

  module NamedScope
    class Scope
      include Sconnect::ScopeExtensions
    end
  end
end
