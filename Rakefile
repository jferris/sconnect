require 'rubygems'
require 'rcov'
require 'spec/rake/spectask'
require 'rake/rdoctask'

Spec::Rake::SpecTask.new do |t|
  t.libs      << 'spec'
  t.spec_opts << '-O spec/spec.opts'
end

desc 'Generate documentation'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Sconnect'
  rdoc.options <<
    '--line-numbers' <<
    '--inline-source' <<
    "--main" <<
    "README.rdoc"
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => :spec
