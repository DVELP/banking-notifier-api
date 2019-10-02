# frozen_string_literal: true

module Dialogflow
  class SessionsClient
    def initialize(keyfile_json:, parameters: {}, session:, utterance:)
      self.keyfile_json = keyfile_json
      self.parameters = parameters
      self.session = session
      self.utterance = utterance
    end

    def detect_text_intent
      @detect_text_intent ||= sessions_client.detect_intent(
        session_string,
        {
          text: {
            text: utterance,
            language_code: language_code
          }
        },
        query_params: { contexts: contexts }
      )
    end

    def detect_event_intent
      @detect_event_intent ||= sessions_client.detect_intent(
        session_string,
        {
          event: {
            name: utterance,
            language_code: language_code
          }
        },
        query_params: { contexts: contexts }
      )
    end

    private

    attr_accessor :keyfile_json, :parameters, :session, :utterance

    def environment_string
      environment_enabled? ? "environments/#{environment}/users/-/" : ''
    end

    def environment_enabled?
      parameters[:environment].present?
    end

    def environment
      parameters[:environment].presence || '-'
    end

    def language_code
      parameters[:language_code] || 'en-GB'
    end

    def session_string
      "projects/#{keyfile['project_id']}/agent/#{environment_string}" \
        "sessions/#{session}"
    end

    def keyfile
      @keyfile ||= JSON.parse(keyfile_json)
    end

    def contexts
      parameters[:contexts].to_a.map do |context|
        {
          lifespan_count: 1,
          name: "#{session_string}/contexts/#{context}",
          parameters: {}
        }
      end
    end

    def sessions_client
      @sessions_client = Google::Cloud::Dialogflow::V2::SessionsClient.new(
        credentials: keyfile
      )
    end
  end
end
