# frozen_string_literal: true

module Bot
  module Responders
    class Base
      include Rails.application.routes.url_helpers

      def initialize(session_uuid:, utterance:)
        self.session_uuid = session_uuid
        self.utterance = utterance
      end

      def to_s
        final_intent? ? final_response : response
      end

      private

      attr_accessor :session_uuid, :utterance

      def session_client
        @session_client ||= Dialogflow::SessionsClient.new(
          keyfile_json: ENV.fetch('GOOGLE_CLOUD_KEYFILE_JSON'),
          parameters: { language_code: 'en-gb' },
          session: session_uuid,
          utterance: utterance
        )
      end

      def intent
        @intent ||= session_client.detect_text_intent.query_result
      end

      def final_intent?
        intent.parameters.to_h['final'].present? ||
          intent.diagnostic_info.to_h['end_conversation']
      end

      def final_response
        Twilio::TwiML::VoiceResponse.new do |response|
          response.say(message: intent.fulfillment_text, voice: 'alice')
          response.hangup
        end
      end

      def response
        Twilio::TwiML::VoiceResponse.new do |r|
          r.gather(
            action: api_twilio_voice_interactions_path,
            input: 'speech',
            speech_timeout: 'auto'
          ) do |gather|
            gather.say(message: intent.fulfillment_text, voice: 'alice')
          end
        end
      end
    end
  end
end
