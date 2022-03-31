# frozen_string_literal: true

require_relative "rails/version"

require "aliyun/rails/connector/roa_client"
require "aliyun/rails/connector/rpc_client"

module Aliyun
  module Rails
    class Error < StandardError; end
    # Your code goes here...
  end
end
