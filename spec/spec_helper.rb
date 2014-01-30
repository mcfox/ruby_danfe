require "simplecov"
SimpleCov.start

require "bundler/setup"
require "ruby_danfe"
require 'rake'

Bundler.require(:default, :development)
Dir[File.dirname(__FILE__) + "/support/*.rb"].each { |f| require f }

load File.expand_path("../../Rakefile", __FILE__)
Rake::Task["spec:fixtures:recreate_pdfs"].invoke
# rake spec:fixtures:recreate_pdfs

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = "random"
end
