class SongController < ApplicationController
#     def new
#         @song = Song.new
#     end
# 
#     def index
#         @page = (params[:page] || 1).to_i
#         @songs = Song.paginate(:page => @page, :per_page => 15)
#     end
# 
#     def create
#         @song = Song.new(params[:song])
#         if @song.save
#             redirect_to '/song/show/' + @song.id
#         else
#             render :action => :new
#         end
#     end
#     
#     def show
#     		@song = Song.find(params[:id])
# 				puts @song.id
#     end
#     
#     # Move the lookup call here
#     # If no track_info then flash

# Probably dont need this
# 	def index
# 		render :json => Song.all
#   end
  
  def show
    render :json => Song.find(params[:id])
  end
  
  def create
    song = Song.create! params
    render :json => song
  end
  
  def new
    song = Song.create! params
    render :json => song
  end
  
  def update
    song = Song.find(params[:id])
    song.update_attributes! params
    render :json => song
  end
end
