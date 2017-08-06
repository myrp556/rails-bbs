class Hex < ActiveRecord::Base
  validates :url, presence: true, length: {in: 10..32}
end
