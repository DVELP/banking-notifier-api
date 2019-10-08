# frozen_string_literal: true

module TwilioIntegration
  class RequestVerificationService
    attr_accessor :validator

    def initialize(validator)
      self.validator = validator
    end

    def verify(uri:, env:)
      params = if env['REQUEST_METHOD'] == 'POST'
                 env['rack.request.form_hash']
               else
                 env['rack.request.query_hash']
               end
      signature = env['HTTP_X_TWILIO_SIGNATURE']
      signature.present? && validator.validate(uri, params, signature)
    end
  end
end
