# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dialogflow::SessionsClient do
  before do
    stub_env(
      'GOOGLE_CLOUD_KEYFILE_JSON' => {
        'project_id' => 'mns-faq-api-test'
      }.to_json
    )
  end

  describe '#detect_text_intent' do
    it 'calls Google::Cloud::Dialogflow::V2::SessionsClient#detect_intent' do
      sessions_client_double = double(
        Google::Cloud::Dialogflow::V2::SessionsClient,
        detect_intent: {}
      )
      allow(Google::Cloud::Dialogflow::V2::SessionsClient)
        .to receive(:new)
        .and_return(sessions_client_double)

      described_class.new(
        keyfile_json: ENV['GOOGLE_CLOUD_KEYFILE_JSON'],
        parameters: {
          contexts: %w[x y],
          environment: 'test',
          language_code: 'en-GB'
        },
        session: 'abc123',
        utterance: 'Return an item'
      ).detect_text_intent

      expect(Google::Cloud::Dialogflow::V2::SessionsClient)
        .to have_received(:new)
        .with(credentials: JSON.parse(ENV['GOOGLE_CLOUD_KEYFILE_JSON']))

      session_string = 'projects/mns-faq-api-test/agent/environments/test/' \
        'users/-/sessions/abc123'
      expected_contexts = [
        {
          lifespan_count: 1,
          name: session_string + '/contexts/x',
          parameters: {}
        },
        {
          lifespan_count: 1,
          name: session_string + '/contexts/y',
          parameters: {}
        }
      ]
      expect(sessions_client_double).to have_received(:detect_intent)
        .with(
          session_string,
          {
            text: {
              text: 'Return an item',
              language_code: 'en-GB'
            }
          },
          query_params: { contexts: expected_contexts }
        )
    end
  end

  describe '#detect_event_intent' do
    it 'calls Google::Cloud::Dialogflow::V2::SessionsClient#detect_intent' do
      sessions_client_double = double(
        Google::Cloud::Dialogflow::V2::SessionsClient,
        detect_intent: {}
      )
      allow(Google::Cloud::Dialogflow::V2::SessionsClient)
        .to receive(:new)
        .and_return(sessions_client_double)

      described_class.new(
        keyfile_json: ENV['GOOGLE_CLOUD_KEYFILE_JSON'],
        parameters: {
          contexts: %w[x y],
          environment: 'test',
          language_code: 'en-GB'
        },
        session: 'abc123',
        utterance: 'WELCOME'
      ).detect_event_intent

      expect(Google::Cloud::Dialogflow::V2::SessionsClient)
        .to have_received(:new)
        .with(credentials: JSON.parse(ENV['GOOGLE_CLOUD_KEYFILE_JSON']))

      session_string = 'projects/mns-faq-api-test/agent/environments/test/' \
        'users/-/sessions/abc123'
      expected_contexts = [
        {
          lifespan_count: 1,
          name: session_string + '/contexts/x',
          parameters: {}
        },
        {
          lifespan_count: 1,
          name: session_string + '/contexts/y',
          parameters: {}
        }
      ]
      expect(sessions_client_double).to have_received(:detect_intent)
        .with(
          session_string,
          {
            event: {
              name: 'WELCOME',
              language_code: 'en-GB'
            }
          },
          query_params: { contexts: expected_contexts }
        )
    end
  end
end
