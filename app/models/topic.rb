class Topic < ActiveRecord::Base
  after_initialize :initilize
  belongs_to :zone
  has_many :notes

  #attr_accessible :detail

  validates :topic_detail, presence:true, length: {in: 3..60}

  def url
    "/topic?id=#{self.id}"
  end

  private
    def initilize
      #self.floor_count = 0
    end
end
