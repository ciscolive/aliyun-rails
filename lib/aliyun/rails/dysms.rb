module Aliyun::Rails
  class Dysms < Aliyun::Rails::Connector::RPCClient

    # 本产品（Dysmsapi/2017-05-25）的OpenAPI采用RPC签名风格，签名细节参见签名机制说明。
    # 我们已经为开发者封装了常见编程语言的SDK，开发者可通过下载SDK直接调用本产品OpenAPI而无需关心技术细节。
    def initialize(config, verbose = nil)

      config["endpoint"]    = "http://dysmsapi.aliyuncs.com"
      config["api_version"] = "2017-05-25"

      super
    end

    # 发送短信，发送前要申请短信签名和短信模板，并确保签名和模板已审核通过。
    def send_sms(phone_numbers, template_code, template_param, sign_name = "")
      params = {
        PhoneNumbers:  phone_numbers,
        SignName:      sign_name,
        TemplateCode:  template_code,
        TemplateParam: template_param.to_json
      }
      opts   = { method: "POST", timeout: 15000 }
      request(action: "SendSms", params: params, opts: opts)
    end
  end
end
