module Twilio
  module Voice
    class InteractionsController < Twilio::BaseController

      def create
        # send to Dialogflow
      	session_client = Dialogflow::SessionsClient.new(
      	  keyfile_json: ENV.fetch('GOOGLE_CLOUD_KEYFILE_JSON'),
      	  parameters: {language_code: 'en-gb'},
      	  session: params[:CallSid], 
      	  utterance: params['SpeechResult'] )
        
        detect_intent = session_client.detect_text_intent

      	# form response
		if detect_intent.query_result.parameters.to_h["final"].present?
          response = Twilio::TwiML::VoiceResponse.new do |r|
            r.say(message: detect_intent.query_result.fulfillment_text, voice: 'alice')
            r.hangup
          end
		else
          response = Twilio::TwiML::VoiceResponse.new do |r|
            r.gather(input: 'speech', action: twilio_voice_interactions_path) do |gather|
              gather.say(message: detect_intent.query_result.fulfillment_text, voice: 'alice')
            end
          end
        end

        render xml: response.to_s
      end
    end
  end
end
