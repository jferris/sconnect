module Sconnect #:nodoc:
  class OrScope < ActiveRecord::NamedScope::Scope #:nodoc:

    delegate :current_scoped_methods, :sanitize_sql, :to => :proxy_scope

    def initialize(left_scope)
      @left_scope  = left_scope.proxy_options
      @proxy_scope = left_scope.proxy_scope
    end

    def proxy_options
      @proxy_options ||= inclusively_combine_scopes(@left_scope, @right_scope)
    end

    private

    def inclusively_combine_scopes(left, right)
      exclusively_combine_scopes(left, right).
        merge(:conditions => combine_conditions(left, right))
    end

    def exclusively_combine_scopes(left, right)
      with_scope(:find => left) do
        with_scope(:find => right) do
          current_scoped_methods[:find]
        end
      end
    end

    def combine_conditions(*scopes)
      segments = scopes.collect do |scope|
        sanitize_sql(scope[:conditions])
      end
      conditions = "(#{segments.join(') OR (')})"
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

  module ScopeExtensions
    # Joins the left and right-hand scopes into an inclusive conditional clause. 
    #
    # Examples:
    #
    #   # Posts published or owned by the user
    #   Post.published.or.owned_by(@user)
    #
    #   # Posts from today that are either published or owned by the given user
    #   # (note that "or" binds tighter than the implicit "and")
    #   Post.from_today.published.or.owned_by(@user)
    def or
      OrScope.new(self)
    end
  end
end
