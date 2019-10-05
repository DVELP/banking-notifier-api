require 'rails_helper'

RSpec.describe Twilio::Voice::IncomingsController, type: :request do
  describe 'Create' do
  	describe 'and success' do

  	  let(:success_text) {'Success'}
  	  let(:ok_result) { 
  	  	double(:detect_intent, query_result: 
  	  		double(:object, fulfillment_text: success_text)) 
  	  }

      before {
        allow_any_instance_of(Dialogflow::SessionsClient).to receive(:detect_event_intent).and_return(ok_result)
  	  }

  	  it 'calls session_client.detect_event_intent' do
        expect_any_instance_of(Dialogflow::SessionsClient).to receive(:detect_event_intent)

        post '/twilio/voice/incomings'
      end

  	  it 'returns correct XML data' do
        post '/twilio/voice/incomings'

        expect(response.content_type).to eq("application/xml; charset=utf-8")

        json_response = Hash.from_xml(response.body) 
        expect(json_response['Response']['Gather']['Say']).to eq(success_text)
        expect(json_response['Response']['Gather']['input']).to eq('speech')
        expect(json_response['Response']['Gather']['action']).to eq(twilio_voice_interactions_path)
      end
  	end
  end
end