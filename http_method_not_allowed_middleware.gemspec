# frozen_string_literal: true
name = "http_method_not_allowed_middleware"
$LOAD_PATH << File.expand_path("lib", __dir__)
require "#{name.tr("-", "/")}/version"

Gem::Specification.new name, HttpMethodNotAllowedMiddleware::VERSION do |s|
  s.summary = "Send 405 response for ActionController::UnknownHttpMethod exceptions"
  s.authors = ["Ryan Clemente"]
  s.email = "kojiee@gmail.com"
  s.homepage = "https://github.com/rcclemente/#{name}"
  s.files = `git ls-files lib/ bin/ MIT-LICENSE`.split("\n")
  s.license = "MIT"
  s.required_ruby_version = ">= 2.3.0"
end
