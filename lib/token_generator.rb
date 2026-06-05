class TokenGenerator
  def self.generate(klass, column)
    key = key_for(column)
    loop do
      raw = friendly_token
      enc = OpenSSL::HMAC.hexdigest("SHA256", key, raw)
      break [ raw, enc ] unless klass.where(column => enc).exists?
    end
  end

  def self.digest(klass, column, value)
    value.present? && OpenSSL::HMAC.hexdigest("SHA256", key_for(column), value.to_s)
  end

  def self.friendly_token(length = 20)
    # To calculate real characters, we must perform this operation.
    # See SecureRandom.urlsafe_base64
    rlength = (length * 3) / 4
    SecureRandom.urlsafe_base64(rlength).tr("lIO0", "sxyz")
  end

  def self.key_for(column)
    @key_generator ||= ActiveSupport::CachingKeyGenerator.new(
      ActiveSupport::KeyGenerator.new(Rails.application.secret_key_base)
    )
    @key_generator.generate_key("Token #{column}")
  end
end
