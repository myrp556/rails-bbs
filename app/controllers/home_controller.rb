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

	def save_page
		data = permit_params params
		dir = Rails.root.join('public', 'save_page')
		cou = 0
		if !data.blank? and !data['html'].blank?
			for filename in Dir.glob(dir.join('*'))
				num = filename.split('/')[-1].split('.')[0]
				cou = num.to_i if num.to_i > cou
			end
			cou += 1
			File.open(dir.join((cou).to_s+'.html'), 'wb') do |file|
				file.write(data['html'])
			end
		end
		respond_to do |format|
			if cou > 0
				format.json { render json: {'message': 'success', 'num': cou} }
			else
				format.json { render json: {'message': 'error'} }
			end
		end
	end

	private
		def get_login
			logged_in?
		end

		def permit_params(params)
			params.require(:data).permit(:html)
		end

end
