class VoteUserAgent < ActiveRecord::Base
  belongs_to :vote
  belongs_to :user
end
