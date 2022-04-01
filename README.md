[English](./README.md) | 简体中文


<p align="center">
<a href=" https://www.alibabacloud.com"><img src="https://aliyunsdk-pages.alicdn.com/icons/Aliyun.svg"></a>
</p>

<h1 align="center">非官方SDK套件-用于RAILS项目管理阿里云相关资源，已集成接口鉴权、短信服务、和语音服务功能</h1>

<p align="center">
<a href="https://badge.fury.io/rb/aliyun-rails"><img src="https://badge.fury.io/rb/aliyun-rails.svg" alt="Gem Version"></a>
<a href="https://travis-ci.org/ciscolive/aliyun-rails"><img src="https://travis-ci.org/ciscolive/aliyun-rails.svg?branch=master" alt="Build Status"></a>
<a href="https://ci.appveyor.com/project/ciscolive/aliyun-rails/branch/master"><img src="https://ci.appveyor.com/api/projects/status/uyepkk5bjbynofvu/branch/master?svg=true" alt="Build status"></a>
<a href="https://codecov.io/gh/ciscolive/aliyun-rails"><img src="https://codecov.io/gh/ciscolive/aliyun-rails/branch/master/graph/badge.svg" alt="codecov"></a>
</p>


- 支持 Rails 轻松访问阿里云服务，例如：弹性云主机（ECS）、负载均衡（SLB）、云监控（CloudMonitor）等。 
- 已集成阿里云短信服务和语音服务，满足日常短信和电话告警需求。

本文档介绍如何安装和使用 aliyun-rails

## 使用诊断

[Troubleshoot](https://troubleshoot.api.aliyun.com/?source=github_sdk) 提供 OpenAPI 使用诊断服务，通过 `RequestID` 或 `报错信息`
，帮助开发者快速定位，为开发者提供解决方案。

## 安装

```sh
$ gem install aliyun-rails
```

## 使用

- 加载模块自动挂载几个常量：Dysms、Dyvms、RPCClient和ROAClient

CALL_TTS 实例：

```ruby
require "aliyun-rails"

client = Aliyun::Dyvms.new(
  access_key_id:     ENV['ACCESS_KEY_ID'],
  access_key_secret: ENV['ACCESS_KEY_SECRET'],
)

# 可以直接将API参数放到RAILS项目 * config/initializers *下
# Aliyun.config do |aliyun|
#   aliyun.access_key_id = "XXX"
#   aliyun.access_key_secret = "YYY"
# end
# 随后直接初始化
# client = Aliyun::Dyvms.new

# 调用语音方法 single_call_by_tts method
response = client.single_call_by_tts("075566668888", "13900001234", "TTS_CODE", { TTS_PARAM: 2022 })

puts response

```

SEND_SMS 示例：

```ruby
require "aliyun-rails"

client = Aliyun::Dysms.new(
  access_key_id:     ENV['ACCESS_KEY_ID'],
  access_key_secret: ENV['ACCESS_KEY_SECRET'],
)

# 可以直接将API参数放到RAILS项目 * config/initializers *下
# Aliyun.config do |aliyun|
#   aliyun.access_key_id = "XXX"
#   aliyun.access_key_secret = "YYY"
# end
# 随后直接初始化
# client = Dysms.new

# 调用短信方法 send_sms method
response = client.send_sms("1380000000", "SMS_10010", { param1: "11" }, "SIGN_NAME")

puts response
```

RPC 示例：

```ruby
require 'aliyun-rails'

# 实例化对象
client = RPCClient.new(
  endpoint:          'http://ros.aliyuncs.com',
  api_version:       '2015-09-01',
  access_key_id:     ENV['ACCESS_KEY_ID'],
  access_key_secret: ENV['ACCESS_KEY_SECRET'],
  security_token:    'TOKEN_KEY'
)

# 请求接口查询
params         = { key: (1..11).to_a.map(&:to_s) }
request_option = { method: 'POST', timeout: 15000 }
response       = client.request(
  action: 'DescribeRegions',
  params: params,
  opts:   request_option
)

puts response

```

ROA 示例：

```ruby
require 'aliyun-rails'

# 初始化对象
client = ROAClient.new(
  endpoint:          'http://ros.aliyuncs.com',
  api_version:       '2015-09-01',
  access_key_id:     ENV['ACCESS_KEY_ID'],
  access_key_secret: ENV['ACCESS_KEY_SECRET'],
)

# 请求接口查询
response = client.request(
  method:  'GET',
  uri:     '/regions',
  options: {
    timeout: 15000
  }
)

puts response.body
```

## 问题

[提交 Issue](https://github.com/ciscolive/aliyun-rails/issues/new/choose)，不符合指南的问题可能会立即关闭。

## 发行说明

每个版本的详细更改记录在[发行说明](CHANGELOG.md)中。

## 贡献

提交 Pull Request 之前请阅读[贡献指南](CONTRIBUTING.md)。

## 许可证

[MIT](LICENSE.txt)