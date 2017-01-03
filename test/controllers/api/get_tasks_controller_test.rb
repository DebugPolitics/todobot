require File.expand_path("../../../test_helper.rb", __FILE__)

class Api::GetTasksControllerTest < ActionController::TestCase

  setup do
    @task = Task.create description: 'test'
  end

  test "POST to create creates the user and responds with a random task" do
    User.any_instance.stubs(:get_random_task).returns(@task)

    assert_difference 'User.count' do
      post :create, params: {
        token: SLACK_VERIFICATION_TOKEN,
        user_id: 'abc123',
        user_name: 'test'
      }
    end

    parsed_response = JSON.parse(response.body)

    assert_response :success
    assert_equal "*🐣 Here’s a task for you to do...*", parsed_response['text']
    assert_equal 1, parsed_response['attachments'].size
    assert_equal 2, parsed_response['attachments'][0]['actions'].size
    assert_equal @task.description, parsed_response['attachments'][0]['text']
    assert_equal %w[complete pass], parsed_response['attachments'][0]['actions'].map { |a| a['name'] }
  end

end
