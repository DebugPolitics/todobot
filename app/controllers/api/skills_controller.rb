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

    begin
      if params.key?(:text)
        text=params[:text].strip
        if text.casecmp?('none')
          # with no skills set, user will match any task regardless of skills
          user.categories.clear
        elsif text.casecmp?('all')
          # subtly different - sets the skills to all the ones currently defined
          user.categories = Category.all
        elsif text.casecmp?('help') || text == '?'
          showHelp
        else
          # absolute (false) or relative (true) mode - never the twain shall mix
          addRemove = text.start_with?('+','-')
          # Nil turns to a valid empty string
          skillsList = text.split(/[,\s]+/)
          adds = []
          removes = []
          skillsList.each do |skill|
            add = true
            if addRemove
              if not skill.start_with?('+','-')
                raise Error("Can't mix addRemove and absolute mode")
              else
                add = skill.start_with?('+')
                skill = skill[1..-1]
              end
            end
            cat = (Category.find_by id: skill) ||
              (Category.where('name like ?', skill + '%')) ||
              raise Error("Unknown skill #{skill}")
            if add
              adds << cat
            else
              removes << cat
            end
          end
          user.categories.transaction do
            user.categories << adds
            user.categories.delete(removes)
          end
        end
      end
    rescue => exception
      exception.message + "\n" + showHelp
    end
  end

  def showHelp
    "Help for /skills:
    Enter skills from the list below separated by commas or spaces:
    #{Category.categoryList}
    You can precede a skill with + or - to add or remove it from your skills.
    You can also use the reserved skills \"All\" and \"None\" which do what you
    would expect.
    "
  end

end
