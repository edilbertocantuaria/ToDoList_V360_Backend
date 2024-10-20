require "simplecov"
SimpleCov.start

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors, with: :threads)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    require "minitest/reporters"
    Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

    def authenticated_header(user)
      token = JsonWebToken.encode(user_id: user.id)
      { token: "#{token}" }
    end

  end
end
