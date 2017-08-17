class Pmail < ActiveRecord::Base
  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validates :mail_detail, presence: true, length: {in: 5..500}
  validates :sender_name, presence: true
  validates :receiver_name, presence: true

end
