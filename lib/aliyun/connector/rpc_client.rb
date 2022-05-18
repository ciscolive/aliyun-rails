require "set"
require "openssl"
require "faraday"
require "active_support/all"

module Aliyun
  module Connector
    class RPCClient

      attr_accessor :endpoint, :api_version, :access_key_id, :access_key_secret,
                    :security_token, :codes, :opts, :verbose

      # 对象初始化属性
      def initialize(config, verbose = false)

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
        opts           = self.opts.merge(opts)
        action         = action.upcase_first if opts[:format_action]
        params         = format_params(params) unless opts[:format_params]
        defaults       = default_params
        params         = { Action: action }.merge(defaults).merge(params)
        method         = (opts[:method] || "GET").upcase
        normalized     = normalize(params)
        canonicalized  = canonicalize(normalized)
        string_to_sign = "#{method}&#{encode('/')}&#{encode(canonicalized)}"
        secret         = "#{self.access_key_secret}&"
        signature      = Base64.encode64(OpenSSL::HMAC.digest("sha1", secret, string_to_sign)).strip
        normalized.push(["Signature", encode(signature)])

        # 转换为 query 样式
        querystring = canonicalize(normalized)

        # 特殊处理 POST
        uri = opts[:method] == "POST" ? "/" : "/?#{querystring}"

        # 初始化会话
        response = connection.send(method.downcase, uri) do |request|
          if opts[:method] == "POST"
            request.headers["Content-Type"] = "application/x-www-form-urlencoded"
            request.body                    = querystring
          end
          request.headers["User-Agent"] = DEFAULT_UA
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
          default_params                  = {
            "Format"           => "JSON",
            "SignatureMethod"  => "HMAC-SHA1",
            "SignatureNonce"   => SecureRandom.hex(16),
            "SignatureVersion" => "1.0",
            "Timestamp"        => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "AccessKeyId"      => self.access_key_id,
            "Version"          => self.api_version,
          }
          default_params["SecurityToken"] = self.security_token if self.security_token
          default_params
        end

        # 消息签名需要
        def encode(string)
          ERB::Util.url_encode(string)
        end

        # 转换 HASH key 样式
        def format_params(param_hash)
          param_hash.keys.each { |key| param_hash[(key.to_s.upcase_first).to_sym] = param_hash.delete key }
          param_hash
        end

        def replace_repeat_list(target, key, repeat)
          repeat.each_with_index do |item, index|
            if item && item.instance_of?(Hash)
              item.each_key { |k| target["#{key}.#{index.next}.#{k}"] = item[k] }
            else
              target["#{key}.#{index.next}"] = item
            end
          end
          target
        end

        def flat_params(params)
          target = {}
          params.each do |key, value|
            if value.instance_of?(Array)
              replace_repeat_list(target, key, value)
            else
              target[key.to_s] = value
            end
          end
          target.to_query
        end

        def normalize(params)
          flat_params(params).sort.to_h.map { |key, value| [encode(key), encode(value)] }
        end

        def canonicalize(normalized)
          normalized.map { |element| "#{element.first}=#{element.last}" }.join("&")
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
