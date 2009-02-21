require 'rubygems'
require 'rcov'
require 'spec/rake/spectask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

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

spec = Gem::Specification.new do |s|
  s.name        = %q{sconnect}
  s.version     = "0.1"
  s.summary     = %q{Sconnect extends ActiveRecord's named scoped_chains to be 
                     more useful an interesting.}
  s.description = %q{Sconnect extends ActiveRecord's named_scope chains to allow
                     scopes to be combined inclusively, inverted, and more.}

  s.files        = FileList['[A-Z]*', 'lib/**/*.rb', 'spec/**/*.rb']
  s.require_path = 'lib'
  s.test_files   = Dir[*['spec/**/*_spec.rb']]

  s.has_rdoc         = true
  s.extra_rdoc_files = ["README.rdoc"]
  s.rdoc_options = ['--line-numbers', '--inline-source', "--main", "README.rdoc"]

  s.authors = ["Joe Ferris"]
  s.email   = %q{jferris@thoughtbot.com}

  s.platform = Gem::Platform::RUBY
end

Rake::GemPackageTask.new spec do |pkg|
  pkg.need_tar = true
  pkg.need_zip = true
end

desc "Clean files generated by rake tasks"
task :clobber => [:clobber_rdoc, :clobber_package]

desc "Generate a gemspec file"
task :gemspec do
  File.open("#{spec.name}.gemspec", 'w') do |f|
    f.write spec.to_ruby
  end
end
