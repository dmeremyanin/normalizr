CodeClimate::TestReporter.start
CodeClimate::TestReporter.configure do |config|
  config.logger.level = Logger::WARN
end
