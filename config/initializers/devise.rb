# frozen_string_literal: true

Devise.setup do |config|
  config.mailer_sender = "please-change-me-at-config-initializers-devise@example.com"

  require "devise/orm/active_record"

  # Authentication
  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.skip_session_storage = [ :http_auth ]
  config.stretches = Rails.env.test? ? 1 : 12

  # Confirmable
  config.reconfirmable = true

  # Rememberable
  config.expire_all_remember_me_on_sign_out = true

  # Validatable
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # Recoverable
  config.reset_password_within = 6.hours

  # API-only: no navigational formats, no session storage
  config.navigational_formats = []
  config.sign_out_via = :delete

  config.warden do |manager|
    manager.scope_defaults :user, store: false
  end

  # JWT via devise-jwt
  config.jwt do |jwt|
    jwt.secret = Rails.application.credentials.devise_jwt_secret_key!
    jwt.dispatch_requests = [
      [ "POST", %r{^/api/v1/login$} ],
      [ "POST", %r{^/api/v1/signup$} ]
    ]
    jwt.revocation_requests = [
      [ "DELETE", %r{^/api/v1/logout$} ]
    ]
    jwt.expiration_time = 24.hours.to_i
  end

  # Hotwire/Turbo defaults
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end
