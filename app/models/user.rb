class User < ActiveRecord::Base
  #404498
  attr_accessor :remember_token, :reset_token, :activation_token
  before_create :create_activation_digest

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

  validates :rank, presence: true, \
    inclusion: {in: 0..2}

  validates :icon, presence:true, allow_nil: true

  has_many :agents
  has_many :vote_user_agents
  has_many :zones, through: :agents
  has_many :votes, through: :vote_user_agents
  has_many :topics
  has_many :notes
  has_many :balls
  has_many :favorites
  #has_many :pmails

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

  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def has_privilege?(thing)
    if !thing.user.nil? and thing.user.id == self.id
      return true
    end
    false
  end

  def is_admin?
    return self.rank > 1
  end

  def high_rank?
    return self.rank > 0
  end

  def has_unread?
    Pmail.where('receiver_id = ? AND readed = ?', self.id, false).size() > 0
  end

  def activate
    update(activated: true)
    update(activated_at: Time.zone.now)
  end
  def send_activation_mail
    UserMail.account_activation(self).deliver_now
  end
  private
    def create_activation_digest
      self.activation_token = User.new_token
      self.actication_digest = User.digest(activation_token)
    end
end
