# frozen_string_literal: true

module Api
  module Twilio
    class BaseController < ApplicationController
      before_action :validate_request

      private

      def validate_request
        request_verification_service =
          TwilioIntegration::RequestVerificationService.new(
            ::Twilio::Security::RequestValidator.new(
              ENV.fetch('TWILIO_AUTH_TOKEN')
            )
          )

        unless request_verification_service.verify(
          uri: request.original_url,
          env: request.env
        )
          render head :ok, status: :unauthorized && return
        end
      end
    end
  end
end
