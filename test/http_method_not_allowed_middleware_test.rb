# frozen_string_literal: true
require_relative "test_helper"

SingleCov.covered!

describe HttpMethodNotAllowedMiddleware do
  describe Middleware do
    before do
      @app    = proc { |_env| [200, {}, []] }
      @router = HttpMethodNotAllowedMiddleware.new(@app)
      @env    = Rack::MockRequest.env_for('/')
    end

    it "gracefully returns 405 for unknown HTTP methods" do
      @env['REQUEST_METHOD'] = 'NO WAY'
      assert_equal 405, @router.call(@env)[0]

      @env['REQUEST_METHOD'] = 'aBcD'
      assert_equal 405, @router.call(@env)[0]
    end

    it "accepts known HTTP methods" do
      ActionDispatch::Request::HTTP_METHODS.each do |method|
        @env['REQUEST_METHOD'] = method
        assert_equal 200, @router.call(@env)[0]
      end
    end
  end

  it "has a VERSION" do
    HttpMethodNotAllowedMiddleware::VERSION.must_match /^[\.\da-z]+$/
  end
end
