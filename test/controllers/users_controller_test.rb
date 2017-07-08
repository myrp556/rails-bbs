require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "create a new user" do
    get "new"
    assert_response :success

    post "create",
      user: {name:"nana", user_name: "nana1", mail: "mm@153.com", 
        number:"114514", 
        password:"123456", password_confirmation:"123456"}
    #put params
    assert_response :redirect
  end


end
