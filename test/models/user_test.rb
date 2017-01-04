require File.expand_path("../../test_helper.rb", __FILE__)

class UserTest < ActiveSupport::TestCase

  setup do
    @task = Task.create description: "test"
    @user = User.create name: "test", slack_id: "abc123"
  end

  test "#get_random_task returns a random task" do
    assert_equal @task, @user.get_random_task
  end

  test "#get_random_task doesn't return a completed task" do
    @user.tasks << @task
    @incomplete_task = Task.create description: "test"

    assert_equal @incomplete_task, @user.get_random_task
  end

  test "#get_random_task doesn't return a task specified to be excluded" do
    @other_task = Task.create description: "test"

    assert_equal @other_task, @user.get_random_task(exclude: @task)
  end

end
