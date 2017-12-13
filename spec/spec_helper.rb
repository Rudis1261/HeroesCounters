require File.dirname(__FILE__) + '/../app.rb'

Dir.glob('../app/{helpers,models,routes}/*.rb').each {|file| require_relative file }

require "rack/test"
require "rspec-html-matchers"

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include RSpecHtmlMatchers
end

RSpec::Matchers.define(:redirect_to) do |url|
  match do |response|
    response.status == 302 && response.headers['Location'].include?(url)
  end
end