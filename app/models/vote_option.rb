class VoteOption < ActiveRecord::Base
  belongs_to :vote

  validates :description, presence: true, length: {in: 3..50}
end
