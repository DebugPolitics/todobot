require File.expand_path("../../../test_helper.rb", __FILE__)

class Api::SkillsControllerTest < ActionController::TestCase
  setup do
    @user = User.create name: 'test', slack_id: 'abc123'
    @cat1 = Category.create name: 'cat1'
    @cat2 = Category.create name: 'cat2'
    @cat3 = Category.create name: 'cat3'
  end

  test "default mode" do
    post :create, params: {
      token: SLACK_VERIFICATION_TOKEN,
      user_id: "abc123",
      user_name: "test",
      command: "/skills",
      text: "Cat1, cat2"
    }

    assert_response :success
    parsed_response = JSON.parse(response.body)
    assert_equal "Your skills are cat1, cat2", parsed_response['text']
  end

  test "addRemove mode" do
    @user.categories <<@cat3
    post :create, params: {
      token: SLACK_VERIFICATION_TOKEN,
      user_id: "abc123",
      user_name: "test",
      command: "/skills",
      text: "+cat1, +Cat2, -cat3"
    }

    assert_response :success
    parsed_response = JSON.parse(response.body)
    assert_equal "Your skills are cat1, cat2", parsed_response['text']
  end

  test "mixed mode should fail" do
    @user.categories <<@cat3
    post :create, params: {
      token: SLACK_VERIFICATION_TOKEN,
      user_id: "abc123",
      user_name: "test",
      command: "/skills",
      text: "+cat1, cat2, -Cat3"
    }

    assert_response :success
    parsed_response = JSON.parse(response.body)
    assert_match /^Can't mix addRemove and absolute mode/, parsed_response['text']
  end

  test "invalid skill should fail" do
    post :create, params: {
      token: SLACK_VERIFICATION_TOKEN,
      user_id: "abc123",
      user_name: "test",
      command: "/skills",
      text: "foofoo"
    }

    assert_response :success
    parsed_response = JSON.parse(response.body)
    assert_match /^Unknown skill foofoo/, parsed_response['text']
  end

  test "valid + invalid skill should fail" do
    post :create, params: {
      token: SLACK_VERIFICATION_TOKEN,
      user_id: "abc123",
      user_name: "test",
      command: "/skills",
      text: "cat1, foofoo"
    }

    assert_response :success
    parsed_response = JSON.parse(response.body)
    assert_match /^Unknown skill foofoo/, parsed_response['text']
  end

  test "all mode" do
    post :create, params: {
      token: SLACK_VERIFICATION_TOKEN,
      user_id: "abc123",
      user_name: "test",
      command: "/skills",
      text: "all"
    }

    assert_response :success
    parsed_response = JSON.parse(response.body)
    assert_match /^Your skills are /, parsed_response['text']
  end

  test "none mode" do
    post :create, params: {
      token: SLACK_VERIFICATION_TOKEN,
      user_id: "abc123",
      user_name: "test",
      command: "/skills",
      text: "none"
    }

    assert_response :success
    parsed_response = JSON.parse(response.body)
    assert_equal "Cleared all your skills", parsed_response['text']
  end

  test "help" do
    post :create, params: {
      token: SLACK_VERIFICATION_TOKEN,
      user_id: "abc123",
      user_name: "test",
      command: "/skills",
      text: "help"
    }

    assert_response :success
    parsed_response = JSON.parse(response.body)
    assert_match /^Help for \/skills:/, parsed_response['text']
  end
end
