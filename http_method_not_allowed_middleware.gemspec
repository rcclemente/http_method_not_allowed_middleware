# frozen_string_literal: true
name = "http_method_not_allowed_middleware"
$LOAD_PATH << File.expand_path("lib", __dir__)
require "#{name.tr("-", "/")}/version"

Gem::Specification.new name, HttpMethodNotAllowedMiddleware::VERSION do |s|
  s.summary = "Send 405 response for ActionController::UnknownHttpMethod exceptions"
  s.authors = ["Ryan Clemente", "Adrian Bordinc"]
  s.email = ["kojiee@gmail.com", "adrian.bordinc@gmail.com"]
  s.homepage = "https://github.com/rcclemente/#{name}"
  s.files = `git ls-files lib/ bin/ MIT-LICENSE`.split("\n")
  s.license = "MIT"
  s.require_paths = ['app/models', 'lib']
  s.required_ruby_version = ">= 2.3.0"

  s.add_dependency 'actionpack'
  s.add_dependency 'rack', '>= 1.6.11'

  s.add_development_dependency 'bump'
  s.add_development_dependency 'byebug'
  s.add_development_dependency "maxitest"
  s.add_development_dependency "mocha", ">= 0.14.0"
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'single_cov'
  s.add_development_dependency 'wwtd'
end
