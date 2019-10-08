# frozen_string_literal: true

module Api
  module Twilio
    module Voice
      class NoResponsesController < Api::Twilio::BaseController
        def create
          response = Bot::Responders::Initial.new(
            session_uuid: params['CallSid'],
            utterance: ENV.fetch('DIALOGFLOW_NO_RESPONSE_EVENT')
          ).to_s

          render xml: response
        end
      end
    end
  end
end
