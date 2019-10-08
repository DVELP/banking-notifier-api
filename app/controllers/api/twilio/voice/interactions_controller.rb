# frozen_string_literal: true

module Api
  module Twilio
    module Voice
      class InteractionsController < Api::Twilio::BaseController
        def create
          response = Bot::Responders::Base.new(
            session_uuid: params['CallSid'],
            utterance: params['SpeechResult']
          ).to_s

          render xml: response
        end
      end
    end
  end
end
