# frozen_string_literal: true
require "action_dispatch"
require "logger"

class HttpMethodNotAllowedMiddleware
  def initialize(app, opts={})
    @app = app
		@logger = @logger_proc = nil
		if logger = opts[:logger]
			if logger.respond_to? :call
				@logger_proc = opts[:logger]
			else
				@logger = logger
			end
		end
  end

  # Gracefully return 405 if we get a request with an unsupported HTTP method
  def call(env)
    if !ActionDispatch::Request::HTTP_METHODS.include?(env["REQUEST_METHOD"].upcase)
      debug(env, "ActionController::UnknownHttpMethod: #{env.inspect}")
      [405, { "Content-Type" => "text/plain" }, ["Method Not Allowed"]]
    else
      @app.call(env)
    end
  end

  def debug?
    @debug_mode
  end

  protected
    def debug(env, message = nil, &block)
      (@logger || select_logger(env)).debug(message, &block) if debug?
    end

    def select_logger(env)
      @logger = if @logger_proc
        logger_proc = @logger_proc
        @logger_proc = nil
        logger_proc.call

      elsif defined?(Rails) && Rails.respond_to?(:logger) && Rails.logger
        Rails.logger

      elsif env[RACK_LOGGER]
        env[RACK_LOGGER]

      else
        ::Logger.new(STDOUT).tap { |logger| logger.level = ::Logger::Severity::DEBUG }
      end
    end
end
