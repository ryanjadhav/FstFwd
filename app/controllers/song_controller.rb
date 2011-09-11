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
            redirect_to '/song/show/' + @song.id
        else
            render :action => :new
        end
    end
    
    def show
    		@song = Song.find(params[:id])
				puts @song.id
    end
    
    # Move the lookup call here
    # If no track_info then flash
end
