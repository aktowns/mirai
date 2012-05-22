# encoding: UTF-8
require 'httparty'
require 'json'

class SpotifyPlugin < Mirai::Plugin
  def on_register
    add_channel_handler(/(spotify:(album|track|artist):[a-zA-Z0-9]+)/, :spotify_link_handler, :trigger => :none)
    add_channel_handler(/(http:\/\/open.spotify.com\/(album|track|artist)\/[a-zA-Z0-9]+)/, :spotify_link_handler, :trigger => :none)
  end

  def spotify_link_handler info, uri, type
    puts "URI: #{uri}"
    puts "Type: #{type}"
    data = get_data(uri)
    case 
    when type.match(/artist/)
      msg info[:chan], "Artist: #{get_artist(data)}" # Artist: Pewpew
    when type.match(/album/)
      album = get_album(data)
      msg info[:chan], "#{album['name']} (#{album['released']}) by #{album['artist']} (#{album['artist_id']})" # Blah (2001) by Pewpew (spotify:artist:abc123)
    when type.match(/track/)
      track = get_track(data)
      msg info[:chan], "#{track['name']} by #{track['artist_name']} (#{track['artist_id']}) from the album #{track['album_name']} (#{track['album_id']})" # Zew by Pewpew (spotify:artist:abc123) from the album Blah (spotify:album:abc123)
    else
      msg info[:chan], "Something went wrong."
    end
  end

  def get_data uri
    data = HTTParty.get("http://ws.spotify.com/lookup/1/.json?uri=#{uri}").body
    return JSON.parse(data) 
  end

  def get_artist data
    return data['artist']['name']
  end

  def get_track data
    info = {}
    info['name'] = data['track']['name']
    info['album_name'] = data['track']['album']['name']
    info['album_id'] = data['track']['album']['href']
    info['artist_name'] = data['track']['artists'][0]['name'] # TODO: Multiple artist support
    info['artist_id'] = data['track']['artists'][0]['href']
    return info
  end

  def get_album data
    info = {}
    info['artist'] = data['album']['artist']
    info['artist_id'] = data['album']['artist-id']
    info['name'] = data['album']['name']
    info['released'] = data['album']['released']
    return info
  end
end