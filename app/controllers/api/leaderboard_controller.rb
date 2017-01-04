class Api::LeaderboardController < Api::ApiController

  def create
    user_names_and_scores = User.all.map { |u| [u.name, u.tasks.sum(:bounty)] }
    user_names_and_scores.sort! { |a, b| b[1] <=> a[1] }

    text = "Here are your leaders...\n"

    user_names_and_scores.each_with_index do |user_name_and_score, i|
      text = "#{text}\n#{i + 1}. #{user_name_and_score[0]} (#{user_name_and_score[1]})"
    end

    render json: { text: text }, status: :ok
  end

end
