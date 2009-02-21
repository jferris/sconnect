require 'rubygems'
require 'rcov'
require 'spec/rake/spectask'

Spec::Rake::SpecTask.new do |t|
  t.libs      << 'spec'
  t.spec_opts << '-O spec/spec.opts'
end

task :default => :spec
