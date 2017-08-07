class User < ActiveRecord::Base
  attr_accessor :remember_token, :reset_token
  before_save {
    self.user_name = user_name.downcase
    self.mail = mail.downcase
  }
  validates :name, presence: true, length: {in: 2..20}, \
    uniqueness: {case_sensitive: false}
  validates :user_name, presence: true,  \
    length: {in: 2..15}, \
    format: {with: /\A[a-z][a-z0-9\_]+\z/}, \
    uniqueness: {case_sensitive: false}
  validates :mail, presence: true, length: {in: 5..50}, \
    format: {with: /\A[a-z0-9\_\-]+@[a-z0-9\-.]+\.[a-z]+\z/i},\
    uniqueness: {case_sensitive: false}
    #attribute: I18n.t(:mail)
  validates :number, presence: true, \
    uniqueness: true, \
    length: {in: 1..10}

  validates :password, presence: true, allow_nil: true, \
    length: {in:6..30}

  validates :icon, presence:true, allow_nil: true

  has_many :topics
  has_many :notes

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

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_passwd_reset_email
    UserMailer.passwd_reset(self).deliver_now
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def has_privilege?(thing)
    if !thing.user.nil? and thing.user.id == self.id
      return true
    end
    false
  end
end
