require "bundler/setup"
Bundler.require(:default, :development)

require "ruby_danfe"

Dir[File.dirname(__FILE__) + "/support/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = "random"
end
