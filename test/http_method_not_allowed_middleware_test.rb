# frozen_string_literal: true
require_relative "test_helper"

SingleCov.covered!

describe HttpMethodNotAllowedMiddleware do
  it "has a VERSION" do
    HttpMethodNotAllowedMiddleware::VERSION.must_match /^[\.\da-z]+$/
  end

  describe 'middleware' do
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

  describe 'logging' do
    let(:response) { [405, { "Content-Type" => "text/plain" }, ["Method Not Allowed"]] }
    let(:logger) { mock }

    before do
      @app = mock
      @app.stubs(:call).returns(response)
    end

    it 'should not log debug messages if debug option is false' do
      logger.expects(:debug).never

      http = HttpMethodNotAllowedMiddleware.new(@app, debug: false, logger: logger)
      http.send(:debug, {}, 'testing')
    end

    it 'should log debug messages if debug option is true' do
      logger.expects(:debug)

      http = HttpMethodNotAllowedMiddleware.new(@app, debug: true, logger: logger)
      http.send(:debug, {}, 'testing')
    end

    let(:env) { Rack::MockRequest.env_for('/') }

    it 'should use rack.logger if available' do
      logger.expects(:debug).at_least_once

      env['REQUEST_METHOD'] = 'NO WAY'
      env['rack.logger'] = logger
      http = HttpMethodNotAllowedMiddleware.new(@app, debug: true)
      http.call(env)
    end

    it 'uses proc logger' do
      logger.expects(:debug)

      env['REQUEST_METHOD'] = 'NO WAY'
      http = HttpMethodNotAllowedMiddleware.new(@app, debug: true, logger: proc { logger })
      http.call(env)
    end

    it 'uses standard out' do
      Logger.expects(:new).with(STDOUT).returns(logger)
      logger.expects(:tap).returns(logger)
      logger.expects(:debug)

      env['REQUEST_METHOD'] = 'STDOUT'
      http = HttpMethodNotAllowedMiddleware.new(@app, debug: true)
      http.call(env)
    end

    describe 'with Rails setup' do
      after do
        ::Rails.logger = nil if defined?(::Rails)
      end

      it 'should use Rails.logger if available' do
        logger.expects(:debug)

        ::Rails = OpenStruct.new(logger: logger)

        env['REQUEST_METHOD'] = 'NO WAY'
        http = HttpMethodNotAllowedMiddleware.new(@app, debug: true)
        http.call(env)
      end
    end
  end
end
