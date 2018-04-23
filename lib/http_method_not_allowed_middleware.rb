# frozen_string_literal: true
class HttpMethodNotAllowedMiddleware
    def initialize(app)
      @app = app
    end

    # Gracefully return 405 if we get a request with an unsupported HTTP method
    def call(env)
      if !ActionDispatch::Request::HTTP_METHODS.include?(env["REQUEST_METHOD"].upcase)
        # Rails.logger.info "ActionController::UnknownHttpMethod: #{env.inspect}"
        [405, {"Content-Type" => "text/plain"}, ["Method Not Allowed"]]
      else
        @app.call(env)
      end
    end
  end
end
