# frozen_string_literal: true

module Aliyun
  module Rails
    class Dysms < Aliyun::Rails::Connector::RPCClient
      # 本产品（Dyvmsapi/2017-05-25）的OpenAPI采用RPC签名风格，签名细节参见签名机制说明。
      # 我们已经为开发者封装了常见编程语言的SDK，开发者可通过下载SDK直接调用本产品OpenAPI而无需关心技术细节。
      def initialize(config, verbose = nil)
        config["endpoint"]    = "http://dyvmsapi.aliyuncs.com"
        config["api_version"] = "2017-05-25"

        super
      end

      # 调用SingleCallByTts接口向指定号码发送语音验证码和带参数变量的语音通知
      def single_call_by_tts(called_show_number, called_number, tts_code, tts_param)
        params = {
          CalledShowNumber: called_show_number,
          CalledNumber:     called_number,
          TtsCode:          tts_code,
          TtsParam:         tts_param.to_json
        }
        opts   = { method: "POST", timeout: 15000 }
        request(action: "SendSms", params: params, opts: opts)
      end
    end
  end
end
