# frozen_string_literal: true

require 'webmock/rspec'
require 'timecop'
require 'vcr'
require 'workato-connector-sdk'
require 'workato/testing/vcr_encrypted_cassette_serializer'
require 'workato/testing/vcr_multipart_body_matcher'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'tape_library'
  config.hook_into :webmock
  config.cassette_serializers[:encrypted] = Workato::Testing::VCREncryptedCassetteSerializer.new
  config.register_request_matcher :headers_without_user_agent do |request1, request2|
    request1.headers.except('User-Agent') == request2.headers.except('User-Agent')
  end
  config.register_request_matcher :multipart_body do |request1, request2|
    Workato::Testing::VCRMultipartBodyMatcher.call(request1, request2)
  end
  config.default_cassette_options = {
    record: ENV.fetch('VCR_RECORD_MODE', :once).to_sym,
    
    match_requests_on: %i[uri headers_without_user_agent body]
  }
  config.configure_rspec_metadata!
end

# FIXME(uwe): Remove when fixed
# https://github.com/vcr/vcr/pull/907/files
module VCR
  class LibraryHooks
    # @private
    module WebMock
      extend self

      def with_global_hook_disabled(request)
        global_hook_disabled_requests << request

        begin
          yield
        ensure
          global_hook_disabled_requests.delete(request)
        end
      end

      def global_hook_disabled?(request)
        requests = Thread.current[:_vcr_webmock_disabled_requests]
        requests && requests.include?(request)
      end

      def global_hook_disabled_requests
        Thread.current[:_vcr_webmock_disabled_requests] ||= []
      end
    end
  end
end
# EMXIF
