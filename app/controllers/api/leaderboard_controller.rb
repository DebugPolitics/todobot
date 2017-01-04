class Api::LeaderboardController < Api::ApiController

  def create
    users = User.all.map { |u| [u.name, u.tasks.sum(:bounty), u.tasks.count] }
    users.sort! { |a, b| b[1] <=> a[1] }

    text = "Here are your leaders...\n"

    users.each_with_index do |user, i|
      name = user[0]
      points = user[1]
      count = user[2]

      text = "#{text}\n#{i + 1}. #{name} " +
        "(#{points} #{"point".pluralize(points)}, " +
        "#{count} #{"tasks".pluralize(count)})"
    end

    render json: { text: text }, status: :ok
  end

end
