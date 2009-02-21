# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sconnect}
  s.version = "0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joe Ferris"]
  s.date = %q{2009-02-21}
  s.description = %q{Sconnect extends ActiveRecord's named_scope chains to allow scopes to be combined inclusively, inverted, and more.}
  s.email = %q{jferris@thoughtbot.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["Rakefile", "README.rdoc", "lib/sconnect/not.rb", "lib/sconnect/or.rb", "lib/sconnect.rb", "spec/not_spec.rb", "spec/or_spec.rb", "spec/spec_helper.rb", "spec/support/active_record_extensions.rb", "spec/support/model_builder.rb", "spec/support/scope_matcher.rb", "spec/support/scope_options_matcher.rb"]
  s.has_rdoc = true
  s.rdoc_options = ["--line-numbers", "--inline-source", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Sconnect extends ActiveRecord's named scoped_chains to be  more useful an interesting.}
  s.test_files = ["spec/not_spec.rb", "spec/or_spec.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
