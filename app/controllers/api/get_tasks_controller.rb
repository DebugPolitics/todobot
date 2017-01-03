class Api::GetTasksController < Api::ApiController
  def create
    user = User.find_or_initialize_by(slack_id: params[:user_id])
    user.name = params[:user_name]
    user.save!

    task = user.get_random_task

    if task.nil?
      render json: { text: 'There are no more tasks for you! Please try again later' },
             status: :ok
    else
      render json: slack_message_from_task(task),
             status: :ok
    end
  end

  private
  def slack_message_from_task task
    {
      "text": "*🐣 Here’s a task for you to do...*",
      "attachments": [
        {
          "text": task.description,
          "fallback": "You are unable to complete a task",
          "callback_id": "tasks",
          "color": "#D3D3D3",
          "attachment_type": "default",
          "actions": [
            {
              "name": "complete",
              "text": "Mark as Done",
              "type": "button",
              "value": task.id,
              "style": "primary"
            }
          ]
        }
      ]
    }
  end
end
