# frozen_string_literal: true

module Bot
  module Responders
    class Initial < Base
      private

      def intent
        @intent ||= session_client.detect_event_intent.query_result
      end
    end
  end
end
