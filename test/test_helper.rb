require 'minitest'
require 'simplecov'
SimpleCov.start
require 'hurley'

def clear_count
  Hurley.get("http://127.0.0.1:9292/clear_count")
end
