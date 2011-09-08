class Song
  include MongoMapper::Document

  key :orig_url, String
  key :fstfwd_id, String
  key :grooveshark_id, String
  key :rdio_id, String
  key :youtube_id, String
  key :spotify_id, String
  key :lastfm_id, String
  key :track_info, String

  after_validation :calculate_services

  private

  def calculate_services
    self.fstfwd_id = calculate_fstfwd_id
    self.track_info = lookup_track_info  
    self.grooveshark_id = calculate_grooveshark_id
    self.rdio_id = calculate_rdio_id
    self.youtube_id = calculate_youtube_id
    self.spotify_id = calculate_spotify_id
    self.lastfm_id = calculate_lastfm_id
  end

  def calculate_fstfwd_id
    # Internal id for fstfwd
    self._id
  end
  
  def lookup_track_info
  	'track info'
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
    # Use the youtube api
    'youtube'
  end

  def calculate_spotify_id
    # Use the spotify api
    'spotify'
  end

  def calculate_lastfm_id
    # Use the lastfm api
    'last.fm'
  end
end
