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
      render json: new_task_message(task),
             status: :ok
    end
  end

end
