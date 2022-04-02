# frozen_string_literal: true

require "set"
require "openssl"
require "faraday"
require "erb"
require "active_support/all"

module Aliyun
  module Connector
    class RPCClient
      attr_accessor :endpoint, :api_version, :access_key_id, :access_key_secret,
                    :security_token, :codes, :opts, :verbose

      # 对象初始化属性
      def initialize(config = {}, verbose = false)
        validate config

        self.endpoint          = config[:endpoint]
        self.api_version       = config[:api_version]
        self.access_key_id     = config[:access_key_id] || Aliyun.access_key_id
        self.access_key_secret = config[:access_key_secret] || Aliyun.access_key_secret
        self.security_token    = config[:security_token]
        self.opts              = config[:opts] || {}
        self.verbose           = verbose.instance_of?(TrueClass) && verbose

        self.codes = Set.new [200, "200", "OK", "Success"]
        self.codes.merge config[:codes] if config[:codes]
      end

      # 通用请求接口
      def request(action:, params: {}, opts: {})
        opts                = self.opts.merge(opts)
        action              = action.upcase_first if opts[:format_action]
        params              = format_params(params) unless opts[:format_params]
        defaults            = default_params
        params              = { Action: action }.merge(defaults).merge(params)
        method              = (opts[:method] || "GET").upcase
        sign                = "#{method}&#{encode('/')}&#{encode(params.to_query)}"
        secret              = "#{self.access_key_secret}&"
        signature           = Base64.encode64(OpenSSL::HMAC.digest("sha1", secret, sign)).strip
        params["Signature"] = signature

        # 转换为 query 样式
        query_string = params.to_query

        # 特殊处理 POST
        uri = opts[:method] == "POST" ? "/" : "/?#{query_string}"

        # 初始化会话
        response = connection.send(method.downcase, uri) do |r|
          if opts[:method] == "POST"
            r.headers["Content-Type"] = "application/x-www-form-urlencoded"
            r.body                    = query_string
          end
          r.headers["User-Agent"] = DEFAULT_UA
        end

        # 解析接口响应
        response_body = JSON.parse(response.body)
        if response_body["Code"] && !response_body["Code"].to_s.empty? && !self.codes.include?(response_body["Code"])
          raise StandardError, "Code: #{response_body['Code']}, Message: #{response_body['Message']}, URL: #{uri}"
        end

        response_body
      end

      private
        def connection(adapter = Faraday.default_adapter)
          Faraday.new(url: self.endpoint) { |f| f.adapter adapter }
        end

        # 设置缺省参数
        def default_params
          params                 = {
            Format:           "JSON",
            SignatureMethod:  "HMAC-SHA1",
            SignatureNonce:   SecureRandom.hex(8),
            SignatureVersion: "1.0",
            Timestamp:        Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ"),
            AccessKeyId:      self.access_key_id,
            Version:          self.api_version,
          }
          params[:SecurityToken] = self.security_token if self.security_token.present?
          params
        end

        # 消息签名需要
        def encode(input)
          ERB::Util.url_encode input
        end

        # 转换 HASH key 样式
        def format_params(param_hash)
          param_hash.keys.each { |key| param_hash[(key.to_s.upcase_first).to_sym] = param_hash.delete key }
          param_hash
        end

        def validate(config = {})
          config.with_indifferent_access
          raise ArgumentError, 'must pass "config"' unless config
          raise ArgumentError, 'must pass "config[:endpoint]"' unless config[:endpoint]
          unless config[:endpoint].match?(/^http[s]?:/i)
            raise ArgumentError, '"config.endpoint" must starts with \'https://\' or \'http://\'.'
          end
          raise ArgumentError, 'must pass "config[:api_version]"' unless config[:api_version]
          unless config[:access_key_id] || Aliyun.access_key_id
            raise ArgumentError, 'must pass "config[:access_key_id]" or define "Aliyun.access_key_id"'
          end
          unless config[:access_key_secret] || Aliyun.access_key_secret
            raise ArgumentError, 'must pass "config[:access_key_secret]" or define "Aliyun.access_key_secret"'
          end
        end
    end
  end
end
