class Api::CompleteTasksController < Api::ApiController
  def create
    # user = User.find_by_slack_id(params[:user][:id])
    # task = Task.find_by_id(params[:actions].first[:value])

    render json: { response_type: 'ephemeral', replace_original: true,
                   text: "Sorry, that didn't work. Please try again."
    }, status: :ok
  end
end