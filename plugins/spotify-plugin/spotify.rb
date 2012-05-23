# encoding: UTF-8
require 'httparty'
require 'json'

class SpotifyPlugin < Mirai::Plugin
  def on_register
    add_channel_handler(/(spotify:(album|track|artist):[a-zA-Z0-9]+)/, :spotify_link_handler, :trigger => :none, :prefix => :none)
    add_channel_handler(/(http:\/\/open.spotify.com\/(album|track|artist)\/[a-zA-Z0-9]+)/, :spotify_link_handler, :trigger => :none, :prefix => :none)
  end

  def spotify_link_handler info, uri, type
    data = get_data(uri)
    data.empty? ? type = "error" : data = JSON.parse(data)
    case 
    when type.match(/artist/)
      msg info[:chan], "Artist: #{get_artist(data)}"
    when type.match(/album/)
      album = get_album(data)
      msg info[:chan], "#{album['name']} (#{album['released']}) by #{album['artist']} (#{album['artist_id']})" 
    when type.match(/track/)
      track = get_track(data)
      artists = track['artists'].map {|t| "#{artists}#{t['name']} (#{t['href']}), "}.join("")
      msg info[:chan], "#{track['name']} by #{artists.chomp(', ')} from the album \"#{track['album_name']}\" (#{track['album_id']})"
    else
      msg info[:chan], "Something went wrong."
    end
  end

  def get_data uri
    return HTTParty.get("http://ws.spotify.com/lookup/1/.json?uri=#{uri}").body
  end

  def get_artist data
    return data['artist']['name']
  end

  def get_track data
    info = {}
    info['name'] = data['track']['name']
    info['album_name'] = data['track']['album']['name']
    info['album_id'] = data['track']['album']['href']
    info['artists'] = data['track']['artists']
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