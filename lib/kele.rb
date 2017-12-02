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
    puts response
    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get('/users/me', headers: { "authorization" => @auth_token })
    @user    = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response             = self.class.get("/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body)
  end

  def get_messages(page)
    response = self.class.get('/message_threads', headers: { "authorization" => @auth_token })
    @message = JSON.parse(response.body)
  end

  def create_message(email, recipient_id, subject, message_body)
    options = {
        sender: email,
        recipient_id: recipient_id,
        subject: subject,
        "stripped-text" => message_body
    }

    response = self.class.post('/messages', body: options, headers: { "authorization" => @auth_token})
    @message = response["sent_message"]
  end

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
    options = {
        checkpoint_id: checkpoint_id,
        assignment_branch: assignment_branch,
        assignment_commit_link: assignment_commit_link,
        comment: comment
    }

    response = self.class.post('/checkpoint_submissions', body: options, headers: { "authorization" => @auth_token})
    @submission = response["created submission"]
  end
end
