class User < ActiveRecord::Base
  attr_accessor :remember_token

  before_save {
    self.user_name = user_name.downcase
    self.mail = mail.downcase
  }
  validates :name, presence: true, length: {in: 2..20}, \
    uniqueness: {case_sensitive: false, message: "name has been used"}
  validates :user_name, presence: true,  \
    length: {in: 5..15}, \
    format: {with: /\A[a-z][a-z0-9\_]+\z/, message: "user name starts with letter and following letters and numbers"}, \
    uniqueness: {case_sensitive: false, message: "user name has been used"}
  validates :mail, presence: true, length: {in: 5..50}, \
    format: {with: /\A[a-z0-9\_\-]+@[a-z0-9\-.]+\.[a-z]+\z/i, message: "please use valid mail address"},\
    uniqueness: {case_sensitive: false, message: "mail address has been used"}
  validates :number, presence: true, \
    uniqueness: true, \
    length: {in: 1..10}

  validates :password, presence: true, allow_nil: true, \
    length: {in:6..30, message: "password should be at least 6 letters long and no more than 30 letters"}

  has_secure_password

  class << self
    # retutn specific string's hash code
    def User.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                        BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # return a token
    def User.new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
