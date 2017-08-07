require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "passwd_reset" do
    mail = UserMailer.passwd_reset
    assert_equal "Passwd reset", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
