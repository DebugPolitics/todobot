class Api::ActionsController < Api::ApiController

  def create
    payload = JSON.parse(params[:payload])
    user = User.find_by_slack_id(payload['user']['id'])

    if user.nil?
      respond_with_error
      return
    end

    callback_id = payload['callback_id']
    action_name = payload['actions'].first['name']
    action_value = payload['actions'].first['value']

    case callback_id
    when 'tasks'
      task = Task.find_by_id(action_value)

      case action_name
      when 'complete'
        if task.present?
          user.tasks << task

          public_message = "*The fantastic @#{user.name} just completed his/her " +
            "#{user.tasks.count.ordinalize} to-do and earned #{task.bounty} " +
            "#{"point".pluralize(task.bounty)} for a total of " +
            "#{user.tasks.sum(:bounty)}:* 🎉\n#{task.description}"
          send_message public_message

          confirmation_message = "✅ *Nice job! You finished this to-do " +
            "item:*\n#{task.description}"

          render json: base_response(confirmation_message), status: :ok
        else
          respond_with_error
        end
      when 'pass'
        task = user.get_random_task(exclude: task)
        text = "Try this one on for size..."

        reply = base_response(nil).merge(new_task_message(task, text: text))
        render json: reply, status: :ok
      end
    end
  end

  private

  def base_response(text)
    { response_type: 'ephemeral', replace_original: true,
      text: text
    }
  end

  def respond_with_error
    error_response = base_response("Sorry, that didn't work. Please try again.")
    render json: error_response, status: :ok
  end

end
