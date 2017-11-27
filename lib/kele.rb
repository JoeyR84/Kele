require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include Roadmap

  base_uri 'https://www.bloc.io/api/v1'

  attr_accessor :email, :password

  def initialize(email, password)

    options = {
      body: {
        email: email,
        password: password
      }
    }

    response    = self.class.post('/sessions', options)
    @auth_token = response["auth_token"]
    puts response
  end

  def get_me
    response = self.class.get('/users/me', headers: { "authorization" => @auth_token })
    @user    = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response             = self.class.get('/mentors/2345139/student_availability', headers: { "authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body)
  end

end
