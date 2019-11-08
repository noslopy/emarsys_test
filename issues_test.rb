# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require_relative './issues.rb'
require 'minitest/autorun'
require 'rack/test'

# test app
class IssuesTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_root_says_hello
    get '/'
    assert last_response.ok?
    assert_equal 'Hello', last_response.body
  end
end
