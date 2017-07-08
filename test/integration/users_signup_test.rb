require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name: "",
          user_name: "username",
          mail: "mail@163.com",
          number: '123',
          password: "y123456",
          password_confirmation: "y123456"
        }
      }
    end
    assert_template 'users/new'
  end
end
