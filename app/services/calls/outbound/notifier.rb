# frozen_string_literal: true

module Calls
  module Outbound
    class Notifier
      include Rails.application.routes.url_helpers

      def initialize(to:)
        self.to = to
      end

      def notify
        rest_client.calls.create(
          url: api_twilio_voice_outbound_calls_url,
          to: to,
          from: from
        )
      end

      private

      attr_accessor :to

      def rest_client
        @rest_client = Twilio::REST::Client.new(
          ENV.fetch('TWILIO_ACCOUNT_SID'),
          ENV.fetch('TWILIO_AUTH_TOKEN')
        )
      end

      def from
        ENV.fetch('TWILIO_FROM_NUMBER')
      end
    end
  end
end
