class SongController < ApplicationController
    def new
        @song = Song.new
    end

    def index
        @page = (params[:page] || 1).to_i
        @songs = Song.paginate(:page => @page, :per_page => 15)
    end

    def create
        @song = Song.new(params[:song])
        if @song.save
            redirect_to '/song'
        else
            render :action => :new
        end
    end
end
