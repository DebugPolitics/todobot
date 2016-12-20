class Api::CompleteTasksController < Api::ApiController
  def create
    parsed_payload = JSON.parse(params[:payload])
    user = User.find_by_slack_id(parsed_payload['user']['id'])
    task = Task.find_by_id(parsed_payload['actions'].first['value'])

    if user.nil? or task.nil?
      render json: error_response, status: :ok
    else
      user.tasks << task
      render json: success_response, status: :ok
    end
  end

  private
  def base_response(text)
    { response_type: 'ephemeral', replace_original: true,
      text: text
    }
  end

  def error_response
    base_response("Sorry, that didn't work. Please try again.")
  end

  def success_response
    base_response("Thanks for completing the task!")
  end
end