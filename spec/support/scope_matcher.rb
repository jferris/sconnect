module Matchers
  def be_chainable
    simple_matcher do |given, matcher| 
      matcher.description = "return a chainable named scope"
      given.class.instance_methods.include?('proxy_scope')
    end
  end
end
