require File.expand_path("../../../test_helper.rb", __FILE__)

class Api::ActionsControllerTest < ActionController::TestCase

  setup do
    @user = User.create name: 'test', slack_id: 'abc123'
    @task = Task.create description: 'test'
  end

  test "POST to create responds with an error without a user" do
    post :create, params: {
      payload: {
        token: SLACK_VERIFICATION_TOKEN,
        user: {
          id: 'zzz999'
        }
      }.to_json
    }

    assert_response :success
    assert_equal "Sorry, that didn't work. Please try again.",
      JSON.parse(response.body)['text']
  end

  test "POST to create responds with an error if the task can't be found" do
    post :create, params: {
      payload: {
        token: SLACK_VERIFICATION_TOKEN,
        callback_id: 'tasks',
        actions: [
          { name: 'complete', value: 0 }
        ],
        user: {
          id: @user.slack_id
        }
      }.to_json
    }

    assert_response :success
    assert_equal "Sorry, that didn't work. Please try again.",
      JSON.parse(response.body)['text']
  end

  test "POST to create completes a task" do
    stubbed_response = stub(body: "{}", parsed_response: {})
    HTTParty.expects(:post).with('https://slack.com/api/chat.postMessage', {
      body: {
        token: SLACK_AUTH_TOKEN,
        channel: SLACK_GENERAL_CHANNEL_ID,
        text: "*The fantastic @#{@user.name} just completed his/her " +
          "1st to-do:* 🎉\n#{@task.description}"
      }
    }).returns(stubbed_response)

    assert_difference '@user.tasks.count' do
      post :create, params: {
        payload: {
          token: SLACK_VERIFICATION_TOKEN,
          callback_id: 'tasks',
          actions: [
            { name: 'complete', value: @task.id }
          ],
          user: {
            id: @user.slack_id
          }
        }.to_json
      }
    end

    assert_response :success
    assert_equal "✅ *Nice job! You finished this to-do item:*\n#{@task.description}",
      JSON.parse(response.body)['text']
    assert_equal 1, @user.tasks.count
  end

  test "POST to create passes on a task" do
    assert_difference '@user.tasks.count' do
      post :create, params: {
        payload: {
          token: SLACK_VERIFICATION_TOKEN,
          callback_id: 'tasks',
          actions: [
            { name: 'complete', value: @task.id }
          ],
          user: {
            id: @user.slack_id
          }
        }.to_json
      }
    end

    assert_response :success
    assert_equal "✅ *Nice job! You finished this to-do item:*\n#{@task.description}",
      JSON.parse(response.body)['text']
  end

end
