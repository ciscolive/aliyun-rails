# frozen_string_literal: true

require_relative "lib/aliyun/version"

Gem::Specification.new do |spec|
  spec.name    = "aliyun-rails"
  spec.version = Aliyun::VERSION
  spec.authors = ["WENWU.YAN"]
  spec.email   = ["careline@foxmail.com"]

  spec.homepage    = "https://github.com/ciscolive/aliyun-rails"
  spec.summary     = "非阿里云官方SDK，本GEM主要实现RAILS项目轻松调用 ** aliyun ** 相关接口"
  spec.description = "支持 Rails 轻松访问阿里云服务，例如：弹性云主机（ECS）、负载均衡（SLB）、云监控（CloudMonitor）等。当前已支持短信服务、语音服务，可以直接调用！"

  spec.license               = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"]   = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ciscolive/aliyun-rails"
  spec.metadata["changelog_uri"]   = "https://github.com/ciscolive/aliyun-rails/blob/main/README.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "LICENSE.txt", "Rakefile",
        "README.md", "CHANGELOG.md", "CODE_OF_CONDUCT.md", "CONTRIBUTING.md"
    ]
  end

  spec.add_dependency "activesupport", ">= 3.0.0"
  spec.add_dependency "faraday", ">= 0.15.4"
end
