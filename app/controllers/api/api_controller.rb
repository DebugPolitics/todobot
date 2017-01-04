class Api::ApiController < ApplicationController

  protect_from_forgery with: :null_session
  before_action :verify_slack_token!

  protected

  def verify_slack_token!
    begin
      if params[:payload].nil?
        token = params[:token]
      else
        parsed_payload = JSON.parse(params[:payload])
        token = parsed_payload['token']
      end

      if SLACK_VERIFICATION_TOKEN != token
        render json: { errors: "Invalid request" }, status: 401
      end
    rescue
      render json: { errors: "Invalid request" }, status: 401
    end
  end

  def send_message(msg, channel = SLACK_GENERAL_CHANNEL_ID)
    HTTParty.post('https://slack.com/api/chat.postMessage', {
      body: {
        token: SLACK_AUTH_TOKEN,
        channel: channel,
        text: msg
      }
    }).parsed_response
  end

  def new_task_message(task, text: "🐣 Here’s a task for you to do...")
    text = "#{text} (earn #{task.bounty} #{"point".pluralize(task.bounty)})"

    {
      "text": text,
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
            },
            {
              "name": "pass",
              "text": "Do Something Else",
              "type": "button",
              "value": task.id
            }
          ]
        }
      ]
    }
  end

end
