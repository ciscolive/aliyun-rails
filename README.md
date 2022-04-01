[English](./README.md) | 简体中文


<p align="center">
<a href=" https://www.alibabacloud.com"><img src="https://aliyunsdk-pages.alicdn.com/icons/Aliyun.svg"></a>
</p>

<h1 align="center">非官方SDK套件-用于RAILS项目管理</h1>

<p align="center">
<a href="https://badge.fury.io/rb/aliyunsdkcore"><img src="https://badge.fury.io/rb/aliyunsdkcore.svg" alt="Gem Version"></a>
<a href="https://travis-ci.org/aliyun/openapi-core-ruby-sdk"><img src="https://travis-ci.org/aliyun/openapi-core-ruby-sdk.svg?branch=master" alt="Build Status"></a>
<a href="https://ci.appveyor.com/project/aliyun/openapi-core-ruby-sdk/branch/master"><img src="https://ci.appveyor.com/api/projects/status/uyepkk5bjbynofvu/branch/master?svg=true" alt="Build status"></a>
<a href="https://codecov.io/gh/aliyun/openapi-core-ruby-sdk"><img src="https://codecov.io/gh/aliyun/openapi-core-ruby-sdk/branch/master/graph/badge.svg" alt="codecov"></a>
</p>


支持 Rails 轻松访问阿里云服务，例如：弹性云主机（ECS）、负载均衡（SLB）、云监控（CloudMonitor）等。

本文档介绍如何安装和使用 aliyun-rails

## 使用诊断
[Troubleshoot](https://troubleshoot.api.aliyun.com/?source=github_sdk) 提供 OpenAPI 使用诊断服务，通过 `RequestID` 或 `报错信息` ，帮助开发者快速定位，为开发者提供解决方案。

## 安装

```sh
$ gem install aliyun-rails
```

## 使用

RPC 示例；

```ruby
require "aliyun-rails"

client = Dysms.new(
  access_key_id:     ENV['ACCESS_KEY_ID'],
  access_key_secret: ENV['ACCESS_KEY_SECRET'],
)

# 可以直接将API参数放到 initializers下
# Aliyun::Rails.config do |i|
# i.access_key_id = "XXX"
# i.access_key_secret = "YYYY"
# end
# 随后直接初始化
# client = Dysms.new

# then use the send_sms method
response = client.send_sms("1380000000", "SMS_10010", {param1: "11"}, "SIGN_NAME")

puts response
```


ROA 示例：

```ruby
require 'aliyun-rails'

client = ROAClient.new(
  endpoint:          'http://ros.aliyuncs.com',
  api_version:       '2015-09-01',
  access_key_id:     ENV['ACCESS_KEY_ID'],
  access_key_secret: ENV['ACCESS_KEY_SECRET'],
)

response = client.request(
  method: 'GET',
  uri: '/regions',
  options: {
    timeout: 15000
  }
)

print response.body
```

## 问题
[提交 Issue](https://github.com/ciscolive/aliyun-rails/issues/new/choose)，不符合指南的问题可能会立即关闭。


## 发行说明
每个版本的详细更改记录在[发行说明](CHANGELOG.md)中。


## 贡献
提交 Pull Request 之前请阅读[贡献指南](CONTRIBUTING.md)。


## 许可证
[MIT](LICENSE.md)