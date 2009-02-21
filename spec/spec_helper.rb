require 'rubygems'
require 'spec'
require 'active_record'

SCONNECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

Dir["#{SCONNECT_ROOT}/spec/support/**/*.rb"].each {|file| require(file) }
$: << "#{SCONNECT_ROOT}/lib"

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => "#{SCONNECT_ROOT}/spec/database.sqlite3"
)

ActiveRecord::Base.logger = Logger.new("#{SCONNECT_ROOT}/spec/spec.log")

Spec::Runner.configure do |config|
  config.include Matchers
end

require 'sconnect'
