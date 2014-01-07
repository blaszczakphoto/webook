require 'rubygems'
require 'test/unit'
require 'dust'
require 'active_support'
require 'initializer'
require 'arbs'
RAILS_ROOT = File.expand_path(File.dirname(__FILE__) + "/../../")
Rails::Initializer.run(:set_load_path)
Rails::Initializer.run(:set_autoload_paths)
ArbsGenerator.run(RAILS_ROOT + "/db/schema.rb")