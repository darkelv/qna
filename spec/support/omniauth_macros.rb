module OmniauthMacros
  def mock_auth_hash(provider, email = nil)
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new(
      'provider' => provider,
      'uid' => '1111111',
      'info' => {
        'email' => email
      }
    )
  end

  def clean_mock_auth
    OmniAuth.config.mock_auth[:github] = nil
  end
end
