class Song 
  include MongoMapper::Document

  key :orig_url, String
  key :fstfwd_id, String
  key :grooveshark_id, String
  key :rdio_id, String
  key :youtube_id, String
  key :spotify_id, String
  key :lastfm_id, String
  key :track_info, Hash

  after_validation :calculate_services

  private

  def calculate_services
    self.fstfwd_id = calculate_fstfwd_id
    self.track_info = lookup_track_info(orig_url)  
    self.grooveshark_id = calculate_grooveshark_id
    self.rdio_id = calculate_rdio_id
    self.youtube_id = calculate_youtube_id
    self.spotify_id = calculate_spotify_id(track_info)
    self.lastfm_id = calculate_lastfm_id
  end

  def calculate_fstfwd_id
    # Internal id for fstfwd
    self._id
  end
  
  # Return a standardized query string
  def create_query(artist, song)
		middle_concat = ''
		if artist 
			artist = artist.gsub(/\s/, '+'); 
		end
		
		if song 
			song = song.gsub(/\s/, '+');
		end
		
		song ? middle_concat = '+' : middle_contcat = ''
		
		return artist + middle_concat + song
  end
  
  # Handle the look up call
  def lookup_track_info(orig_url)
		if orig_url.include?('http://')
			orig_url = orig_url.sub('http://', '')
		end
		
		split_url = orig_url.split('/')
		
		puts split_url[0]
		
		track_info = Hash.new();
		
		#This needs to be better, include only track urls of specific services
 		if split_url[0] == 'open.spotify.com'
 			puts 'spotify lookup'
			track_info = spotify_lookup(split_url[2])
# 		else if split_url[0] == 'www.last.fm' || split_url[0] == 'last.fm'
# 			print 'lastfm lookup'
# 		else if split_url[0] == 'www.grooveshark.com' || split_url[0] == 'grooveshark.com'
# 			print 'grooveshark lookup'
# 		else if split_url[0] == 'rd.io'
# 			print 'rdio lookup'
		else
			# Return an empty track_info hash
			puts 'non-valid url'
		end
		
		return track_info
  end

  def calculate_grooveshark_id
    # Use the grooveshark api
    'grooveshark'
  end

  def calculate_rdio_id
    # Use rdio api
    'rdio'
  end

  def calculate_youtube_id
		#Use youtube api
		'youtube'
  end
  
  def spotify_lookup(spotify_uri)
  	# #Call spotify metadata api
    url = 'http://ws.spotify.com/lookup/1/.json?uri=spotify:track:' + spotify_uri
		resp = Net::HTTP.get_response(URI.parse(url)) 
		data = resp.body
		result = JSON.parse(data)
		
		if result.has_key?('track')  
			track_info = Hash['artist', result['track']['artists'][0]['name'], 'track', result['track']['name']]
		else
			track_info = Hash.new
		end
		
		puts track_info.inspect
		
		return track_info 
  end

  def calculate_spotify_id(track_info)
  	puts track_info.inspect
  
  	# Prep a query
  	if track_info.has_key?('artist')
  		query = create_query(track_info['artist'], track_info['track'])
  	else
  		# We're defaulting to this for now
  		query = "Thrice+Deadbolt"
    end
  	
    # Call spotify metadata api
    url = 'http://ws.spotify.com/search/1/track.json?q=' + query
		resp = Net::HTTP.get_response(URI.parse(url))
		data = resp.body
		result = JSON.parse(data)
		
		if result.has_key?('tracks')
			spotify_href = result['tracks'][0]['href']
			spotify_id = spotify_href.split(':').last
		else
			spotify_id = 0
		end
		
		return spotify_id
  end

  def calculate_lastfm_id
    # Use the lastfm api
    'last.fm'
  end
end
