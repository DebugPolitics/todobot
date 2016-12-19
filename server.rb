require 'sinatra'
require 'logger'
require 'httparty'

enable :logging

before do
  logger.level = Logger::DEBUG
end

get '/oauth' do
  code = params[:code]
  client_id = ENV['SLACK_CLIENT_ID']
  secret = ENV['SLACK_SECRET']
  logger.info "OAuth Exchange Code = #{code}"

  response = HTTParty.post('https://slack.com/api/oauth.access', 
                           body: {client_id: client_id,
                                  client_secret: secret,
                                  code: code}).parsed_response
  access_token = response["access_token"]
  logger.info "Access Token = #{access_token}"
end