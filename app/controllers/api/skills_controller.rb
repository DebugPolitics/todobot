class Api::SkillsController < Api::ApiController

  def create
    user = User.find_or_initialize_by(slack_id: params[:user_id])
    user.name = params[:user_name]
    user.save!

    # Try to make the input as flexible as possible:
    # * match a comma or space separated list of skills, by number or name
    # e.g. 'Eng,Sales','1,2'
    # * skills can be preceded by + or - to add or remove the skill
    # e.g. '+Des,-Sa'; removing a skill you don't have is a no-op
    # * the strings 'all' or 'none'
    # * anything else, including mixing known and unknown skills in a list,
    # or empty text, will make no changes and print help:
    # "Enter your skills from the following list:
    # 1-Engineering, 2-Sales, 3-Design, 4-Copywriting"
    # as well as text indicating the above +,-,all,none
    # Also, mixing +- and bare numbers will result in the help text -
    # I figure it's too confusing to accept "1,2,+3"
    addRemove = false

    if params.key?(:text)
      # Nil turns to a valid empty string
      skillsList = String(params[:text]).split(/[,\s]+/)
      skillsList.each do |skill|

      end

    end

  end

  def categoryList
    if @@categoryList is nil
      @@categoryList = Category.all.map { |c| "#{c.id} - #{c.name}"}.join(", ")
    end
    @@categoryList
  end

  def showHelp
    text = "Help for /skills:
    Enter skills from the following list below separated by commas or spaces:
    #{self.categoryList}
    You can precede a skill with + or - to add or remove it from your skills.
    You can also use the reserved skills \"All\" and \"None\" which do what you
    would expect.
    "
  end

end
