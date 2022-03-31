# frozen_string_literal: true

require_relative "rails/version"

require "aliyun/rails/version"
require "aliyun/rails/connector/roa_client"
require "aliyun/rails/connector/rpc_client"
require "aliyun/rails/dysms"
require "aliyun/rails/dyvms"

module Aliyun
  module Rails
    class Error < StandardError; end

    class << self
      def config(&block)
        RPCClient.init_params(&block)
      end
    end
    # Your code goes here...
  end
end
