module OmniauthMacros
  def github_mock_auth_hash
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      'provider' => 'github',
      'uid' => '123123',
      'info' => {
        'name' => 'MockUser',
        'email' => 'mockuser@example.com'
      },
      'credentials' => {
        'token' => 'mock_token'
      }
    })
  end
end
