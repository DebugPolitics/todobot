class Api::GetTasksController < Api::ApiController
  before_filter :verify_slack_token!

  def create
    user = User.find_or_initialize_by(slack_id: params[:user_id])
    user.name = params[:user_name]
    user.save!

    task = user.get_random_task

    if task.nil?
      render json: { text: 'There are no more tasks for you! Please try again later' },
             status: :ok
    else
      render json: { text: task.description, status: :ok }
    end
  end

  private
  def verify_slack_token!
    if SLACK_VERIFICATION_TOKEN != params[:token]
      render json: { errors: "Invalid request" }, status: 401
    end
  end
end