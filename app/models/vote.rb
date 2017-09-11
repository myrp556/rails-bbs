class Vote < ActiveRecord::Base
  belongs_to :topic
  has_many :vote_user_agents
  has_many :vote_options
  has_many :users, through: :vote_user_agents

  validates :vote_options, presence: true
end
