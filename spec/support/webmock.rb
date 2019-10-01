# frozen_string_literal: true

require 'webmock/rspec'

RSpec.configure do |_config|
  WebMock.stub_request(:any, "#{ENV['ELASTICSEARCH_URL']}/*")
    .to_return(status: 200, body: '', headers: {})
end

WebMock.disable_net_connect!(allow_localhost: true)
