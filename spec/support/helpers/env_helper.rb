# frozen_string_literal: true

def stub_env(hash)
  stub_const('ENV', ENV.to_h.merge(hash))
end
