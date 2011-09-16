require 'uri'
require 'json'

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

#		after_validation :calculate_services
    
    def to_json(options = {})
    	puts 'opts:'
			puts options.inspect

    	super(options.merge(:only => [ :id, :created_at, :orig_url, :fstfwd_id, :spotify_id, :grooveshark_id, :lastfm_id, :rdio_id, :youtube_id, :track_info]))
    end

    private

    def calculate_services  
        self.fstfwd_id = calculate_fstfwd_id
        self.track_info = lookup_track_info(orig_url)  

        puts self.track_info.inspect

        self.grooveshark_id = calculate_grooveshark_id(track_info)
        self.rdio_id = calculate_rdio_id
        self.youtube_id = calculate_youtube_id
        self.spotify_id = calculate_spotify_id(track_info)
        self.lastfm_id = calculate_lastfm_id(track_info)
    end

    # Return a FstFwd Id
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
        uri = URI.parse(orig_url)
        
        split_url = uri.path.split('/')

        puts uri.host
        
        track_info = Hash.new();

        #This needs to be better, include only track urls of specific services
        if uri.host == 'open.spotify.com'
            puts 'spotify lookup'
            track_info = spotify_lookup(split_url[2])
        elsif uri.host.ends_with? 'last.fm'
            puts 'lastfm lookup'
            track_info = last_fm_lookup(split_url[2], split_url[4])
        elsif uri.host.ends_with? 'grooveshark.com'
            track_info = grooveshark_lookup('', split_url[2])
        elsif uri.host == 'rd.io'
            print 'rdio lookup'
        else
            # Return an empty track_info hash
            puts 'non-valid url'
        end

        return track_info
    end

    def grooveshark_lookup(artist, track)
        {'artist' => artist, 'track'=> track}
    end

    def calculate_grooveshark_id(track_info)
        # Prep a query
        if track_info.has_key?('artist')
            query = create_query(track_info['artist'], track_info['track'])
        end

        # Use the grooveshark/tinysong api
        url = 'http://tinysong.com/a/'+ query +'?format=json&key=b4385955bd9dd410287d0b3c7ffee5c8'  
        resp = Net::HTTP.get_response(URI.parse(url)) 
        data = resp.body

        data = data.gsub(/"/, '')
        data = data.gsub(/\\/, '')

        grooveshark_id = data

        return grooveshark_id
    end

    def calculate_rdio_id
        # Use rdio api
        'rdio'
    end

    def calculate_youtube_id
        # Use youtube api
        'youtube'
    end

    def spotify_lookup(spotify_uri)
        # Call spotify metadata api
        url = 'http://ws.spotify.com/lookup/1/.json?uri=spotify:track:' + spotify_uri
        resp = Net::HTTP.get_response(URI.parse(url)) 
        data = resp.body
        result = JSON.parse(data)

        if result.has_key?('track')  
            track_info = {'artist' => result['track']['artists'][0]['name'], 'track' => result['track']['name']}
        else
            track_info = Hash.new
        end

        puts track_info.inspect

        return track_info 
    end

    def calculate_spotify_id(track_info)  
        # Prep a query
        if track_info.has_key?('artist')
            query = create_query(track_info['artist'], track_info['track'])
        end
        puts "query = #{query}"

        # Call spotify metadata api
        url = 'http://ws.spotify.com/search/1/track.json?q=' + query
        resp = Net::HTTP.get_response(URI.parse(url))
        data = resp.body
        result = JSON.parse(data)

        if result.has_key?('tracks') and not result['tracks'].empty?
            spotify_href = result['tracks'][0]['href']
            spotify_id = spotify_href.split(':').last
        else
            spotify_id = 0
        end
    end

    def last_fm_lookup(artist, track)
        {'artist' => artist, 'track' => track}
    end

    def calculate_lastfm_id(track_info)
        # Prep the data fields
        artist = track_info['artist'].gsub(/\s/, '+')
        track = track_info['track'].gsub(/\s/, '+')

        # Call the Last FM api
        url = 'http://ws.audioscrobbler.com/2.0/?method=track.getinfo&format=json&api_key=0cc6c91b6bf535eddc5fd9526eec1bb6&artist=' + artist + '&track=' + track
        resp = Net::HTTP.get_response(URI.parse(url))
        data = resp.body
        result = JSON.parse(data)

        if result.has_key?('track')
            last_fm_id = result['track']['url']
        else
            last_fm_id = 0
        end
    end
end
