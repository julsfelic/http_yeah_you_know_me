require 'minitest'
require "mocha/mini_test"
require 'simplecov'
SimpleCov.start
require 'hurley'

def clear_count
  Hurley.get("http://127.0.0.1:9292/clear_count")
end

def wrapper(html)
  "<html><head></head><body>#{html}</body></html>"
end
