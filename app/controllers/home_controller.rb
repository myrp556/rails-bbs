class HomeController < ApplicationController
	def index
    @zones = Zone.all
	end
end
