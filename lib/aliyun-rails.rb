# frozen_string_literal: true

require_relative "aliyun/version"
require_relative "aliyun/connector/roa_client"
require_relative "aliyun/connector/rpc_client"
require_relative "aliyun/dysms"
require_relative "aliyun/dyvms"

module Aliyun
  class Error < StandardError; end

  # 模块单例方法
  class << self
    attr_accessor :access_key_id, :access_key_secret
    def config
      yield self
    end
  end
end

# 加载模块，自动初始化的常量
RPCClient = Aliyun::Connector::RPCClient
ROAClient = Aliyun::Connector::ROAClient
Dysms = Aliyun::Dysms
Dyvms = Aliyun::Dyvms
