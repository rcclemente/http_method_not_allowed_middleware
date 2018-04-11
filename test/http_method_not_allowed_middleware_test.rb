# frozen_string_literal: true
require_relative "test_helper"

SingleCov.covered!

describe HttpMethodNotAllowedMiddleware do
  it "has a VERSION" do
    HttpMethodNotAllowedMiddleware::VERSION.must_match /^[\.\da-z]+$/
  end
end
