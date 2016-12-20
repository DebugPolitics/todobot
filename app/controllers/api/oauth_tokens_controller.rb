class Api::OauthTokensController < Api::ApiController
  skip_before_filter :verify_slack_token!

  def index
    code = params[:code]
    Rails.logger.info "OAuth Exchange Code = #{code}"

    response = HTTParty.post('https://slack.com/api/oauth.access',
                             body: {client_id: SLACK_CLIENT_ID,
                                    client_secret: SLACK_SECRET,
                                    code: code }).parsed_response
    access_token = response["access_token"]
    Rails.logger.info "Access Token = #{access_token}"

    render json: {response: 'ok'},
           status: :ok
  end
end