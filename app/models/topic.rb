class Topic < ActiveRecord::Base
  belongs_to :zone
  has_many :notes
end
