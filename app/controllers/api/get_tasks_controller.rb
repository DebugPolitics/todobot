class Api::GetTasksController < Api::ApiController
  before_filter :verify_slack_token!
  def create
    render json: { text: 'Hello world!' }, status: :ok
  end

  private
  def verify_slack_token!
    if SLACK_VERIFICATION_TOKEN != params[:token]
      render json: { errors: "Invalid request" }, status: 401
    end
  end
end