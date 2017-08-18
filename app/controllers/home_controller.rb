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
	end

	private
		def get_login
			logged_in?
		end

end
