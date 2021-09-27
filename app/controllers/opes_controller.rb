class OpesController < ApplicationController
	def index
		@streamers = Streamer.all
		@streamer = Streamer.where(username: params[:streamer]).first
  end
end