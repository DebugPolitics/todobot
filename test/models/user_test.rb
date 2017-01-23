require File.expand_path("../../test_helper.rb", __FILE__)

class UserTest < ActiveSupport::TestCase

  setup do
    @task = Task.create description: "test"
    @user = User.create name: "test", slack_id: "abc123"
    @category1 = Category.create name: "Cat1"
    @category2 = Category.create name: "Cat2"
    @category3 = Category.create name: "Cat3"
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

  test "#when a user selects skills, get_random_task doesn't return a task that specifies different skills" do
    @user.categories << @category1
    @task.categories << @category2

    assert_nil @user.get_random_task
  end

  test "#when a user selects skills, get_random_task does return a task that specifies those skills" do
    @other_task = Task.create description: "test2"
    @other_task.categories << @category2
    @user.categories << @category1
    @user.categories << @category3
    @task.categories << @category2
    @task.categories << @category3

    assert_equal @task, @user.get_random_task
  end

  test "#when a user selects skills, get_random_task returns tasks with no skills specified" do
    @user.categories << @category1
    @other_task = Task.create description: "test2"
    @other_task.categories << @category2

    assert_equal @task, @user.get_random_task
  end

  test "#when a user hasn't selected skills, get_random_task still works normally" do
    @task.categories << @category2

    assert_equal @task, @user.get_random_task
  end

end
