# frozen_string_literal: true
require "bundler/setup"

require "single_cov"
SingleCov.setup :minitest

require "maxitest/autorun"
require 'mocha/setup'
require "rack/mock"

require "http_method_not_allowed_middleware/version"
require "http_method_not_allowed_middleware"
