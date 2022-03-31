# frozen_string_literal: true

module Aliyun
  module Rails
    VERSION = "0.1.4"
    DEFAULT_UA = "AlibabaCloud (#{Gem::Platform.local.os}; " +
      "#{Gem::Platform.local.cpu}) Ruby/#{RUBY_VERSION} Core/#{VERSION}"
  end
end
