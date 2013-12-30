require "simplecov"
SimpleCov.start

require "bundler/setup"
require "ruby_danfe"

Bundler.require(:default, :development)
Dir[File.dirname(__FILE__) + "/support/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = "random"
end
