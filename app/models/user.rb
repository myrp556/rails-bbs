class User < ActiveRecord::Base
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
    format: {with: /\A[a-zA-Z0-9\_\-]+@[a-zA-Z0-9]+\.[a-zA-Z]+\z/i, message: "please use valid mail address"},\
    uniqueness: {case_sensitive: false, message: "mail address has been used"}
  validates :number, presence: true

  validates :password, presence: true, \
    length: {in:6..30, message: "password should be at least 6 letters long and no more than 30 letters"}

  has_secure_password
end
