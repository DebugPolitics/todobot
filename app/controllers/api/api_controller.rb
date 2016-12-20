class Api::ApiController < ApplicationController
  protect_from_forgery with: :null_session
  before_filter :verify_slack_token!

  protected
  def verify_slack_token!
    if SLACK_VERIFICATION_TOKEN != params[:token]
      render json: { errors: "Invalid request" }, status: 401
    end
  end
end