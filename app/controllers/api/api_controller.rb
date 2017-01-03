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
end
