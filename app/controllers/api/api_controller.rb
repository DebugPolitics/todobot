class Api::ApiController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :verify_slack_token!

  protected
  def verify_slack_token!
    begin
      if params[:payload].nil?
        token = params[:token]
      else
        parsed_payload = JSON.parse(params[:payload])
        token = parsed_payload['token']
      end

      if SLACK_VERIFICATION_TOKEN != token
        render json: { errors: "Invalid request" }, status: 401
      end
    rescue
      render json: { errors: "Invalid request" }, status: 401
    end
  end

  def send_message(msg, channel = SLACK_GENERAL_CHANNEL_ID)
    HTTParty.post('https://slack.com/api/chat.postMessage', {
      body: {
        token: SLACK_AUTH_TOKEN,
        channel: channel,
        text: msg
      }
    }).parsed_response
  end
end
