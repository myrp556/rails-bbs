class HomeController < ApplicationController
	before_action :get_login
	def index
    @zones = Zone.all
		@info = []
		for zone in @zones
			num_topics = Topic.where('zone_id = ?', zone.id).size()
			num_notes = Note.where('zone_id = ?', zone.id).size()
			@info.push({'zone': zone, 'num_topics': num_topics, 'num_notes': num_notes})
		end
		@hot_topics = Topic.all.order("updated_at DESC").first(Settings.hot_topic_num)
	end

	private
		def get_login
			logged_in?
		end

end
