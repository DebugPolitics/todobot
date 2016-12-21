class Api::CompleteTasksController < Api::ApiController
  def create
    parsed_payload = JSON.parse(params[:payload])
    user = User.find_by_slack_id(parsed_payload['user']['id'])
    @task = Task.find_by_id(parsed_payload['actions'].first['value'])

    if user.nil? || @task.nil?
      render json: error_response, status: :ok
    else
      user.tasks << @task
      user_name = parsed_payload['user']['name']
      public_message = "*The fantastic @#{user_name} just completed his/her " +
        "#{user.tasks.count.ordinalize} to-do:* 🎉\n#{@task.description}"
      announce_task_completion public_message
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
    base_response("#{✅} #{@task.description}")
  end

  def announce_task_completion(msg)
    HTTParty.post('https://slack.com/api/chat.postMessage',
                  body: { token: SLACK_AUTH_TOKEN,
                          channel: SLACK_GENERAL_CHANNEL_ID,
                          text: msg }).parsed_response
  end
end
