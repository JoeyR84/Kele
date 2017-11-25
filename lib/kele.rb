require 'httparty'

class Kele
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'

  attr_accessor :email, :password

  def initialize(email, password)

    options = {
      body: {
        email: email,
        password: password
      }
    }

    response = self.class.post('/sessions', options)
    puts response
    @auth_token = response.body["auth_token"]
  end
end
