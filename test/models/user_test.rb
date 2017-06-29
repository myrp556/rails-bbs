require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name:"name", user_name: "user_name", mail: "email@163.com", rank: 0, zone_auth:0, number:1, \
                    password: "y123456", password_confirmation: "y123456")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "user name should be valid" do
    @user.user_name = "999"
    assert_not @user.valid?
  end

  test "user name should not be too long" do
    @user.user_name = "a" * 15 + '100'
    assert_not @user.valid?
  end

  test "valid user name" do
    @user.user_name = "myrp_556"
    assert @user.valid?
  end

  test "mail address should be valid"do
    @user.mail = "11111.com"
    assert_not @user.valid?
  end

  test "user name should be unique" do
    dupulicate_user = @user.dup
    @user.save
    assert_not dupulicate_user.valid?
  end

  test "user name should be low case" do
    @user.user_name = "Upcase"
    assert_not @user.valid?
  end

  test "user name should not be start without letter" do
    @user.user_name = "999yyy"
    assert_not @user.valid?
  end

  test "mail address low case unique"do
    dupulicate_user = @user.dup
    @user.save
    dupulicate_user.mail = dupulicate_user.mail.upcase
    assert_not dupulicate_user.valid?
  end

  test "password should be same" do
    @user.password_confirmation = "b123456"
    assert_not @user.valid?
  end

  test "password should not be too short" do
    @user.password = "1234"
    @user.password_confirmation = "1234"
    assert_not @user.valid?
  end
end
