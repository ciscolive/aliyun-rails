# frozen_string_literal: true

require_relative "rails/version"
require_relative "rails/connector/roa_client"
require_relative "rails/connector/rpc_client"
require_relative "rails/dyvms"
require_relative "rails/dysms"

module Aliyun
  module Rails
    class Error < StandardError; end

    class << self
      attr_accessor :access_key_id, :access_key_secret
      def config
        yield self
      end
    end

    # Your code goes here...
  end
end
