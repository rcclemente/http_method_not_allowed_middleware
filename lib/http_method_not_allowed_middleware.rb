# frozen_string_literal: true
require "action_dispatch"
require "logger"

class HttpMethodNotAllowedMiddleware
  RACK_LOGGER = 'rack.logger'

  def initialize(app, opts = {})
    @app = app
    @debug = opts[:debug]
    @logger = @logger_proc = nil
    if opts[:logger]
      if opts[:logger].respond_to? :call
        @logger_proc = opts[:logger]
      else
        @logger = opts[:logger]
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
    @debug ||= false
  end

  protected

  def debug(env, message = nil)
    (@logger || select_logger(env)).debug(message) if debug?
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
