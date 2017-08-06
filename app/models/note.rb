class Note < ActiveRecord::Base
  after_initialize :initilize
  belongs_to :topic
  belongs_to :user
  
  validates :note_detail, presence:true, length: {in: 6..10000}

  def edit_url
    "/edit_reply?id=#{self.id}"
  end

  def delete_url
    "/delete_reply?id=#{self.id}"
  end

  def update_url
    "/update_reply?id=#{self.id}"
  end

  private
    def initilize
      #self.floor = 0
    end
end
