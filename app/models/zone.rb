class Zone < ActiveRecord::Base
  has_many :topics

  validates :name, presence: true, length: {in: 5..35}
  validates :description, presence: true, length: {in: 3..50}

  def url
    "/zone?id=#{self.id}"
  end

end