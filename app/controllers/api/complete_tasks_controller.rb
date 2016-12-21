class Api::CompleteTasksController < Api::ApiController
  def create
    parsed_payload = JSON.parse(params[:payload])
    user = User.find_by_slack_id(parsed_payload['user']['id'])
    task = Task.find_by_id(parsed_payload['actions'].first['value'])

    if user.nil? or task.nil?
      render json: error_response, status: :ok
    else
      user.tasks << task
      user_name = parsed_payload['user']['name']
      public_message = <<-EOS.strip_heredoc
        *The fantastic @#{user_name} has just finished this to-do:* 🎉
        #{task.description}
         *That’s #{'to-do'.pluralize(user.tasks.count)} _done_ for #{user.name}!*"
      EOS
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
    base_response("Thanks for completing the task!")
  end

  def announce_task_completion(msg)
    HTTParty.post('https://slack.com/api/chat.postMessage',
                  body: { token: SLACK_AUTH_TOKEN,
                          channel: SLACK_GENERAL_CHANNEL_ID,
                          text: msg }).parsed_response
  end
end
