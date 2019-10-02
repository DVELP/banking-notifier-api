module Twilio
  module Voice
    class IncomingsController < Twilio::BaseController
      
      def create
      	# Forward welcome event to Google Dialogflow
      	session_client = Dialogflow::SessionsClient.new(
      	  keyfile_json: ENV.fetch('GOOGLE_CLOUD_KEYFILE_JSON'),
      	  parameters: {language_code: 'en-gb'},
      	  session: params[:CallSid], 
      	  utterance: 'Welcome')

      	detect_intent = session_client.detect_event_intent

      	# form response
        response = Twilio::TwiML::VoiceResponse.new do |r|
          r.gather(input: 'speech', action: twilio_voice_interactions_path) do |gather|
            gather.say(message: detect_intent.query_result.fulfillment_text, voice: 'alice')
          end
        end

      	# return hello message
        render xml: response.to_s 
      end
    end
  end
end
