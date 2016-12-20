namespace :ping do
  desc "Pings HEROKU_URL to keep a dyno alive"
  task dyno: :environment do
    Rails.logger.info('Keeping the dyno alive...')
    HTTParty.get ENV.fetch('HEROKU_URL', '')
    Rails.logger.info('Done!')
  end
end